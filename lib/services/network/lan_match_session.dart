import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// TCP control channel and UDP realtime channel for a two-player LAN session.
/// TCP frames are uint32 big-endian length-prefixed UTF-8 JSON messages.
class LanMatchSession {
  static const int protocolVersion = 1;
  static const int tcpPort = 40444;
  static const int discoveryPort = 40445;

  ServerSocket? _server;
  Socket? _tcp;
  RawDatagramSocket? _udp;
  RawDatagramSocket? _discovery;
  StreamSubscription<List<int>>? _tcpSubscription;
  final StreamController<Map<String, dynamic>> _messages =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _errors = StreamController<String>.broadcast();
  final List<int> _tcpBuffer = [];
  InternetAddress? _peerAddress;
  int? _peerUdpPort;
  int _sequence = 0;
  int _lastReceivedSequence = -1;
  final Map<int, DateTime> _sentTimes = {};
  Timer? _heartbeat;
  DateTime _lastPacket = DateTime.now();
  DateTime _rateWindowStart = DateTime.now();
  int _receivedInWindow = 0;
  bool _timeoutReported = false;
  bool _closed = false;

  Stream<Map<String, dynamic>> get messages => _messages.stream;
  Stream<String> get errors => _errors.stream;
  int get localUdpPort => _udp?.port ?? 0;
  Duration get timeSinceLastPacket => DateTime.now().difference(_lastPacket);

  /// Returns a private IPv4 address from an active, non-loopback interface.
  /// Wi-Fi interfaces are preferred when the platform exposes their names.
  static Future<String?> currentLanAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    final candidates = <({String name, InternetAddress address})>[];
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        if (address.isLoopback || address.isLinkLocal) continue;
        final octets = address.address.split('.').map(int.tryParse).toList();
        if (octets.length != 4 || octets.any((value) => value == null)) continue;
        final a = octets[0]!;
        final b = octets[1]!;
        final isPrivate = a == 10 ||
            (a == 172 && b >= 16 && b <= 31) ||
            (a == 192 && b == 168);
        if (isPrivate) candidates.add((name: interface.name.toLowerCase(), address: address));
      }
    }
    if (candidates.isEmpty) return null;
    candidates.sort((left, right) {
      int priority(String name) {
        if (name.contains('wlan') || name.contains('wifi') || name == 'en0') return 0;
        if (name.contains('eth') || name.contains('en')) return 1;
        return 2;
      }
      return priority(left.name).compareTo(priority(right.name));
    });
    return candidates.first.address.address;
  }

  Future<void> host() async {
    _udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _udp!.listen(_onDatagram, onError: (Object error) => _errors.add('$error'));
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, tcpPort,
        shared: false);
    _server!.listen(_acceptPeer, onError: (Object error) => _errors.add('$error'));
    _discovery = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      discoveryPort,
      reuseAddress: true,
    );
    _discovery!.listen((event) {
      if (event != RawSocketEvent.read) return;
      final datagram = _discovery?.receive();
      if (datagram == null || datagram.data.length > 256) return;
      try {
        final request = jsonDecode(utf8.decode(datagram.data));
        if (request is Map && request['type'] == 'discover' && !_closed) {
          final response = utf8.encode(jsonEncode({
            'type': 'lan_host',
            'protocol': protocolVersion,
            'tcpPort': tcpPort,
          }));
          _discovery?.send(response, datagram.address, datagram.port);
        }
      } catch (_) {
        // Ignore malformed discovery packets.
      }
    }, onError: (Object error) => _errors.add('$error'));
  }

  /// Broadcasts a LAN discovery request on active IPv4 interfaces and returns
  /// host addresses that answered. This does not open a TCP connection.
  static Future<List<String>> scanForHosts({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    final found = <String>{};
    final done = Completer<void>();
    final subscription = socket.listen((event) {
      if (event != RawSocketEvent.read) return;
      final datagram = socket.receive();
      if (datagram == null || datagram.data.length > 256) return;
      try {
        final response = jsonDecode(utf8.decode(datagram.data));
        if (response is Map &&
            response['type'] == 'lan_host' &&
            response['protocol'] == protocolVersion &&
            response['tcpPort'] == tcpPort) {
          found.add(datagram.address.address);
        }
      } catch (_) {
        // Ignore malformed responses.
      }
    });
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      final request = utf8.encode(jsonEncode({
        'type': 'discover',
        'protocol': protocolVersion,
      }));
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          final parts = address.address.split('.');
          if (parts.length != 4 || address.isLoopback || address.isLinkLocal) {
            continue;
          }
          final broadcast = InternetAddress('${parts[0]}.${parts[1]}.${parts[2]}.255');
          socket.send(request, broadcast, discoveryPort);
        }
      }
      Timer(timeout, () {
        if (!done.isCompleted) done.complete();
      });
      await done.future;
      return found.toList()..sort();
    } finally {
      await subscription.cancel();
      socket.close();
    }
  }

  Future<void> join(String hostAddress) async {
    final address = InternetAddress.tryParse(hostAddress.trim());
    if (address == null || address.type != InternetAddressType.IPv4) {
      throw const FormatException('Nhập địa chỉ IPv4 hợp lệ, ví dụ 192.168.1.20');
    }
    _peerAddress = address;
    _udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _udp!.listen(_onDatagram, onError: (Object error) => _errors.add('$error'));
    _tcp = await Socket.connect(address, tcpPort,
        timeout: const Duration(seconds: 5));
    _listenTcp(_tcp!);
    sendControl({
      'type': 'hello',
      'protocol': protocolVersion,
      'udpPort': localUdpPort,
    });
  }

  void _acceptPeer(Socket socket) {
    if (_tcp != null || _closed) {
      socket.destroy();
      return;
    }
    _tcp = socket;
    _peerAddress = socket.remoteAddress;
    _listenTcp(socket);
    sendControl({
      'type': 'host_ready',
      'protocol': protocolVersion,
      'udpPort': localUdpPort,
    });
  }

  void _listenTcp(Socket socket) {
    _tcpSubscription = socket.listen((bytes) {
      _tcpBuffer.addAll(bytes);
      _drainFrames();
    }, onError: (Object error) {
      _errors.add('Kết nối TCP lỗi: $error');
    }, onDone: () {
      if (!_closed) _errors.add('Đối thủ đã ngắt kết nối.');
    });
  }

  void _drainFrames() {
    while (_tcpBuffer.length >= 4) {
      final header = ByteData.sublistView(Uint8List.fromList(_tcpBuffer), 0, 4);
      final length = header.getUint32(0, Endian.big);
      if (length == 0 || length > 65536) {
        _errors.add('Gói TCP không hợp lệ.');
        close();
        return;
      }
      if (_tcpBuffer.length < length + 4) return;
      final body = Uint8List.fromList(_tcpBuffer.sublist(4, 4 + length));
      _tcpBuffer.removeRange(0, 4 + length);
      try {
        final decoded = jsonDecode(utf8.decode(body));
        if (decoded is! Map<String, dynamic>) continue;
        if (decoded['protocol'] != protocolVersion &&
            (decoded['type'] == 'hello' || decoded['type'] == 'host_ready')) {
          _errors.add('Hai máy đang dùng phiên bản giao thức khác nhau.');
          close();
          return;
        }
        if (decoded['type'] == 'hello') {
          _peerUdpPort = decoded['udpPort'] as int?;
          sendControl({'type': 'hello_ack', 'protocol': protocolVersion});
        }
        if (decoded['type'] == 'host_ready') {
          _peerUdpPort = decoded['udpPort'] as int?;
        }
        _messages.add(decoded);
      } catch (_) {
        _errors.add('Bỏ qua gói TCP bị lỗi định dạng.');
      }
    }
  }

  void sendControl(Map<String, Object?> message) {
    final socket = _tcp;
    if (socket == null || _closed) return;
    final payload = Uint8List.fromList(utf8.encode(jsonEncode(message)));
    final frame = BytesBuilder(copy: false)
      ..add((ByteData(4)..setUint32(0, payload.length, Endian.big)).buffer.asUint8List())
      ..add(payload);
    socket.add(frame.takeBytes());
  }

  void sendRealtime(Map<String, Object?> payload) {
    final udp = _udp;
    final address = _peerAddress;
    final port = _peerUdpPort;
    if (udp == null || address == null || port == null || _closed) return;
    final packet = <String, Object?>{
      'protocol': protocolVersion,
      'sequence': ++_sequence,
      'sentAt': DateTime.now().millisecondsSinceEpoch,
      ...payload,
    };
    if (packet['type'] == 'heartbeat') _sentTimes[_sequence] = DateTime.now();
    final bytes = utf8.encode(jsonEncode(packet));
    if (bytes.length <= 1200) udp.send(bytes, address, port);
  }

  void startHeartbeat() {
    _heartbeat?.cancel();
    _lastPacket = DateTime.now();
    _timeoutReported = false;
    _heartbeat = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (timeSinceLastPacket > const Duration(seconds: 2) && !_timeoutReported) {
        _timeoutReported = true;
        _errors.add('Đối thủ mất kết nối UDP.');
        unawaited(close());
        return;
      }
      sendRealtime({'type': 'heartbeat'});
    });
  }

  void _onDatagram(RawSocketEvent event) {
    if (event != RawSocketEvent.read) return;
    final datagram = _udp?.receive();
    if (datagram == null || datagram.data.length > 1200) return;
    try {
      final packet = jsonDecode(utf8.decode(datagram.data));
      if (packet is! Map<String, dynamic> ||
          packet['protocol'] != protocolVersion) return;
      final now = DateTime.now();
      if (now.difference(_rateWindowStart) >= const Duration(seconds: 1)) {
        _rateWindowStart = now;
        _receivedInWindow = 0;
      }
      if (++_receivedInWindow > 120) return;
      final receivedSequence = packet['sequence'];
      if (receivedSequence is int) {
        if (receivedSequence <= _lastReceivedSequence) return;
        _lastReceivedSequence = receivedSequence;
      }
      _lastPacket = now;
      _peerAddress ??= datagram.address;
      if (packet['type'] == 'heartbeat') {
        _peerUdpPort = datagram.port;
        final response = utf8.encode(jsonEncode({
          'protocol': protocolVersion,
          'type': 'heartbeat_ack',
          'ackSequence': packet['sequence'],
          'sentAt': packet['sentAt'],
        }));
        _udp?.send(response, datagram.address, datagram.port);
      }
      if (packet['type'] == 'heartbeat_ack') {
        final sent = _sentTimes.remove(packet['ackSequence']);
        if (sent != null) {
          packet['rttMs'] = DateTime.now().difference(sent).inMilliseconds;
        }
      }
      _messages.add(packet);
    } catch (_) {
      // Malformed UDP packets are intentionally ignored.
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _heartbeat?.cancel();
    await _tcpSubscription?.cancel();
    _tcp?.destroy();
    await _server?.close();
    _udp?.close();
    _discovery?.close();
    await _messages.close();
    await _errors.close();
  }

  /// Sends an orderly room departure before releasing the sockets.
  Future<void> leaveRoom() async {
    if (_closed) return;
    sendControl({'type': 'room_left', 'reason': 'player_left'});
    try {
      await _tcp?.flush().timeout(const Duration(milliseconds: 400));
    } catch (_) {
      // Still close locally if the peer is unreachable.
    }
    await close();
  }
}
