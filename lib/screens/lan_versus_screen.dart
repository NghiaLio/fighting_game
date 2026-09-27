import 'dart:async';
import 'dart:developer';

import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/services/network/lan_match_session.dart';
import 'package:flutter/material.dart';

class LanVersusScreen extends StatefulWidget {
  const LanVersusScreen({super.key});

  @override
  State<LanVersusScreen> createState() => _LanVersusScreenState();
}

class _LanVersusScreenState extends State<LanVersusScreen> {
  final _session = LanMatchSession();
  final _ipController = TextEditingController();
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<String>? _errorSubscription;
  CharacterType _character = CharacterType.fireWizard;
  CharacterType _opponentCharacter = CharacterType.knight1;
  String _status = 'Tạo phòng hoặc nhập IPv4 của Host để tham gia.';
  bool _hosting = false;
  bool _connected = false;
  bool _peerReady = false;
  bool _myReady = false;
  bool _busy = false;
  bool _scanning = false;
  bool _ipEdited = false;
  bool _roomEnded = false;
  bool _handedOff = false;
  int _rttMs = 0;

  @override
  void initState() {
    super.initState();
    _messageSubscription = _session.messages.listen(_onMessage);
    _errorSubscription = _session.errors.listen(_onSessionError);
    unawaited(_fillCurrentWifiAddress());
  }

  void _onSessionError(String message) {
    if (!mounted) return;
    final disconnected = message.contains('ngắt kết nối') ||
        message.contains('Kết nối TCP lỗi') ||
        message.contains('mất kết nối');
    setState(() {
      _status = disconnected ? 'Đối thủ đã ngắt kết nối.' : message;
      if (disconnected) {
        _connected = false;
        _peerReady = false;
        _myReady = false;
        _roomEnded = true;
      }
    });
    if (disconnected) unawaited(_session.close());
  }

  Future<void> _fillCurrentWifiAddress() async {
    try {
      final address = await LanMatchSession.currentLanAddress();
      if (!mounted || _ipEdited || address == null) return;
      _ipController.text = address;
    } catch (_) {
      // Keep manual entry available when the platform does not expose interfaces.
    }
  }

  void _onMessage(Map<String, dynamic> message) {
    if (!mounted) return;
    switch (message['type']) {
      case 'host_ready':
      case 'hello_ack':
        setState(() {
          _connected = true;
          _status = 'Đã kết nối. Đang chờ cấu hình phòng...';
        });
        _session.startHeartbeat();
        if (_hosting) _sendRoomConfig();
        break;
      case 'hello':
        if (_hosting) {
          setState(() {
            _connected = true;
            _status = 'Đối thủ đã vào phòng. Chọn nhân vật rồi sẵn sàng.';
          });
          _sendRoomConfig();
          _session.startHeartbeat();
        }
        break;
      case 'room_config':
        final name = message['hostCharacter'] as String?;
        final type = CharacterType.values.where((value) => value.name == name);
        setState(() {
          if (!_hosting && type.isNotEmpty) _opponentCharacter = type.first;
          _status = 'Đã nhận cấu hình từ Host. Chọn sẵn sàng để xác nhận.';
        });
        break;
      case 'player_config':
        final name = message['character'] as String?;
        final type = CharacterType.values.where((value) => value.name == name);
        if (_hosting && type.isNotEmpty) {
          setState(() => _opponentCharacter = type.first);
        }
        break;
      case 'player_ready':
        setState(() => _peerReady = message['ready'] == true);
        if (_hosting && _myReady && _peerReady) _startNetworkMatch();
        break;
      case 'room_left':
        setState(() {
          _connected = false;
          _peerReady = false;
          _myReady = false;
          _roomEnded = true;
          _status = 'Đối thủ đã rời phòng.';
        });
        unawaited(_session.close());
        break;
      case 'match_start':
        final hostName = message['hostCharacter'] as String?;
        final clientName = message['clientCharacter'] as String?;
        final hostType = CharacterType.values.where((value) => value.name == hostName);
        final clientType = CharacterType.values.where((value) => value.name == clientName);
        _launchNetworkMatch(
          player: _hosting ? _character : (clientType.isNotEmpty ? clientType.first : _character),
          enemy: _hosting ? _opponentCharacter : (hostType.isNotEmpty ? hostType.first : _opponentCharacter),
          host: _hosting,
        );
        break;
      case 'heartbeat_ack':
        final rtt = message['rttMs'];
        if (rtt is int) setState(() => _rttMs = rtt);
        break;
    }
  }

  void _sendRoomConfig() {
    _session.sendControl({
      'type': 'room_config',
      'hostCharacter': _character.name,
      'map': 1,
      'rounds': 3,
    });
  }

  void _launchNetworkMatch({
    required CharacterType player,
    required CharacterType enemy,
    required bool host,
  }) {
    if (_handedOff || !mounted) return;
    _handedOff = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GamePlayScreen(
          playerCharacter: player,
          enemyCharacter: enemy,
          networkSession: _session,
          networkHost: host,
        ),
      ),
    );
  }

  Future<void> _host() async {
    setState(() {
      _busy = true;
      _hosting = true;
      _status = 'Đang mở phòng LAN...';
    });
    try {
      await _session.host();
      if (mounted)
        setState(() {
          _busy = false;
          _status = 'Đang chờ đối thủ. TCP cổng ${LanMatchSession.tcpPort}.';
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _busy = false;
          _hosting = false;
          _status = 'Không thể mở phòng: $error';
        });
    }
  }

  Future<void> _join() async {
    setState(() {
      _busy = true;
      _status = 'Đang kết nối tới Host...';
    });
    try {
      await _session.join(_ipController.text);
      if (mounted)
        setState(() {
          _busy = false;
          _status = 'Đã kết nối, đang đồng bộ phòng...';
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _busy = false;
          _status = 'Kết nối thất bại: $error';
        });
    }
  }

  Future<void> _scanForHost() async {
    setState(() {
      _scanning = true;
      _status = 'Đang quét các phòng PvP trong mạng Wi-Fi hiện tại...';
    });
    try {
      final hosts = await LanMatchSession.scanForHosts();
      log('Found hosts: $hosts');
      if (!mounted) return;
      if (hosts.isEmpty) {
        setState(() {
          _scanning = false;
          _status =
              'Không tìm thấy phòng. Kiểm tra Host đã tạo phòng và cùng mạng Wi-Fi.';
        });
        return;
      }
      final selected = hosts.length == 1
          ? hosts.first
          : await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Chọn phòng tìm thấy'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: hosts
                      .map(
                        (ip) => ListTile(
                          leading: const Icon(Icons.sports_kabaddi),
                          title: Text(ip),
                          onTap: () => Navigator.pop(context, ip),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
      if (!mounted) return;
      if (selected != null) {
        _ipController.text = selected;
        _ipEdited = true;
      }
      setState(() {
        _scanning = false;
        _status = selected == null
            ? 'Đã tìm thấy ${hosts.length} phòng.'
            : 'Đã điền IP Host: $selected';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _scanning = false;
          _status = 'Không quét được mạng hiện tại: $error';
        });
      }
    }
  }

  void _toggleReady() {
    _myReady = !_myReady;
    _session.sendControl({'type': 'player_ready', 'ready': _myReady});
    if (!_hosting) {
      _session.sendControl({'type': 'player_config', 'character': _character.name});
    }
    setState(
      () => _status = _myReady ? 'Bạn đã sẵn sàng.' : 'Bạn chưa sẵn sàng.',
    );
    if (_hosting && _myReady && _peerReady) _startNetworkMatch();
  }

  void _startNetworkMatch() {
    _session.sendControl({
      'type': 'match_start',
      'rounds': 3,
      'hostCharacter': _character.name,
      'clientCharacter': _opponentCharacter.name,
    });
    _launchNetworkMatch(player: _character, enemy: _opponentCharacter, host: true);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _errorSubscription?.cancel();
    _ipController.dispose();
    if (!_handedOff) unawaited(_session.leaveRoom());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF111113),
    appBar: AppBar(
      title: const Text('PvP qua mạng LAN'),
      backgroundColor: const Color(0xFF1E100A),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                if (_connected)
                  Text(
                    'UDP RTT: ${_rttMs}ms  •  ${_peerReady ? 'Đối thủ sẵn sàng' : 'Đối thủ chưa sẵn sàng'}',
                    style: const TextStyle(color: Colors.amber),
                  ),
                const SizedBox(height: 20),
                DropdownButtonFormField<CharacterType>(
                  value: _character,
                  dropdownColor: const Color(0xFF28211B),
                  decoration: const InputDecoration(
                    labelText: 'Nhân vật của bạn',
                    labelStyle: TextStyle(color: Colors.amber),
                    border: OutlineInputBorder(),
                  ),
                  items: CharacterType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ),
                      )
                      .toList(),
                  onChanged: _roomEnded
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _character = value);
                            if (_hosting && _connected) _sendRoomConfig();
                            if (!_hosting && _connected) {
                              _session.sendControl({'type': 'player_config', 'character': value.name});
                            }
                          }
                        },
                ),
                // const SizedBox(height: 16),
                if (!_hosting)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ipController,
                          onChanged: (_) => _ipEdited = true,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'IPv4 LAN (tự lấy từ Wi-Fi)',
                            hintText: 'IP của Host khi tham gia phòng',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _scanning || _busy ? null : _scanForHost,
                        icon: _scanning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.wifi_find),
                        label: Text(_scanning ? 'ĐANG QUÉT' : 'QUÉT IP'),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    if (!_connected && !_roomEnded)
                      FilledButton(
                        onPressed: _busy || _hosting ? null : _host,
                        child: const Text('TẠO PHÒNG'),
                      ),
                    if (!_connected && !_hosting && !_roomEnded)
                      FilledButton(
                        onPressed: _busy ? null : _join,
                        child: const Text('THAM GIA'),
                      ),
                    if (_connected && !_roomEnded)
                      FilledButton(
                        onPressed: _toggleReady,
                        child: Text(_myReady ? 'HỦY SẴN SÀNG' : 'SẴN SÀNG'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cả hai thiết bị cần chung Wi-Fi/hotspot. Host cần cho phép ứng dụng qua firewall.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
