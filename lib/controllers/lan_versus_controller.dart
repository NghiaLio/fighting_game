import 'dart:async';
import 'dart:developer';

import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/services/network/lan_match_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanVersusController extends GetxController {
  static LanVersusController get to => Get.find<LanVersusController>();

  final session = LanMatchSession();
  final ipController = TextEditingController();
  
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<String>? _errorSubscription;
  
  final character = CharacterType.fireWizard.obs;
  final opponentCharacter = CharacterType.knight1.obs;
  
  final status = 'Create a room or enter Host IPv4 to join.'.obs;
  final hosting = false.obs;
  final connected = false.obs;
  final peerReady = false.obs;
  final myReady = false.obs;
  final busy = false.obs;
  final scanning = false.obs;
  
  bool _ipEdited = false;
  final roomEnded = false.obs;
  bool _handedOff = false;
  
  final rttMs = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _messageSubscription = session.messages.listen(_onMessage);
    _errorSubscription = session.errors.listen(_onSessionError);
    unawaited(_fillCurrentWifiAddress());
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    _errorSubscription?.cancel();
    ipController.dispose();
    if (!_handedOff) {
      unawaited(session.leaveRoom());
    }
    super.onClose();
  }

  void _onSessionError(String message) {
    final disconnected = message.contains('ngắt kết nối') ||
        message.contains('Kết nối TCP lỗi') ||
        message.contains('mất kết nối');
        
    status.value = disconnected ? 'Opponent has disconnected.' : message;
    
    if (disconnected) {
      connected.value = false;
      peerReady.value = false;
      myReady.value = false;
      roomEnded.value = true;
      unawaited(session.close());
    }
  }

  Future<void> _fillCurrentWifiAddress() async {
    try {
      final address = await LanMatchSession.currentLanAddress();
      if (_ipEdited || address == null) return;
      ipController.text = address;
    } catch (_) {
      // Keep manual entry available
    }
  }

  void setIpEdited() {
    _ipEdited = true;
  }

  void setCharacter(CharacterType type) {
    character.value = type;
    if (hosting.value && connected.value) {
      _sendRoomConfig();
    } else if (!hosting.value && connected.value) {
      session.sendControl({
        'type': 'player_config',
        'character': type.name
      });
    }
  }

  void _onMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'host_ready':
      case 'hello_ack':
        connected.value = true;
        status.value = 'Connected. Waiting for room configuration...';
        session.startHeartbeat();
        if (hosting.value) _sendRoomConfig();
        break;
        
      case 'hello':
        if (hosting.value) {
          connected.value = true;
          status.value = 'Opponent joined. Choose hero and ready up.';
          _sendRoomConfig();
          session.startHeartbeat();
        }
        break;
        
      case 'room_config':
        final name = message['hostCharacter'] as String?;
        final type = CharacterType.values.where((value) => value.name == name);
        if (!hosting.value && type.isNotEmpty) {
          opponentCharacter.value = type.first;
        }
        status.value = 'Received config from Host. Ready up to confirm.';
        break;
        
      case 'player_config':
        final name = message['character'] as String?;
        final type = CharacterType.values.where((value) => value.name == name);
        if (hosting.value && type.isNotEmpty) {
          opponentCharacter.value = type.first;
        }
        break;
        
      case 'player_ready':
        final selectedName = message['character'] as String?;
        final selectedType = CharacterType.values.where((value) => value.name == selectedName);
        if (hosting.value && selectedType.isNotEmpty) {
          opponentCharacter.value = selectedType.first;
        }
        peerReady.value = message['ready'] == true;
        if (hosting.value && myReady.value && peerReady.value) {
          _startNetworkMatch();
        }
        break;
        
      case 'room_left':
        connected.value = false;
        peerReady.value = false;
        myReady.value = false;
        roomEnded.value = true;
        status.value = 'Opponent left the room.';
        unawaited(session.close());
        break;
        
      case 'match_start':
        final hostName = message['hostCharacter'] as String?;
        final clientName = message['clientCharacter'] as String?;
        final hostType = CharacterType.values.where((value) => value.name == hostName);
        final clientType = CharacterType.values.where((value) => value.name == clientName);
        
        _launchNetworkMatch(
          player: hosting.value ? character.value : (clientType.isNotEmpty ? clientType.first : character.value),
          enemy: hosting.value ? opponentCharacter.value : (hostType.isNotEmpty ? hostType.first : opponentCharacter.value),
          host: hosting.value,
        );
        break;
        
      case 'heartbeat_ack':
        final rtt = message['rttMs'];
        if (rtt is int) rttMs.value = rtt;
        break;
    }
  }

  void _sendRoomConfig() {
    session.sendControl({
      'type': 'room_config',
      'hostCharacter': character.value.name,
      'map': 1,
      'rounds': 3,
    });
  }

  void _launchNetworkMatch({
    required CharacterType player,
    required CharacterType enemy,
    required bool host,
  }) {
    if (_handedOff) return;
    _handedOff = true;
    
    Get.off(
      () => GamePlayScreen(
        playerCharacter: player,
        enemyCharacter: enemy,
        networkSession: session,
        networkHost: host,
      ),
    );
  }

  Future<void> host() async {
    busy.value = true;
    hosting.value = true;
    status.value = 'Opening LAN room...';
    
    try {
      await session.host();
      busy.value = false;
      status.value = 'Waiting for opponent. TCP port ${LanMatchSession.tcpPort}.';
    } catch (error) {
      busy.value = false;
      hosting.value = false;
      status.value = 'Failed to open room: $error';
    }
  }

  Future<void> join() async {
    busy.value = true;
    status.value = 'Connecting to Host...';
    
    try {
      await session.join(ipController.text);
      busy.value = false;
      status.value = 'Connected, synchronizing room...';
    } catch (error) {
      busy.value = false;
      status.value = 'Connection failed: $error';
    }
  }

  Future<void> scanForHost(BuildContext context) async {
    scanning.value = true;
    status.value = 'Scanning for PvP rooms in the current Wi-Fi...';
    
    try {
      final hosts = await LanMatchSession.scanForHosts();
      log('Found hosts: $hosts');
      
      if (hosts.isEmpty) {
        scanning.value = false;
        status.value = 'No rooms found. Ensure Host created room on same Wi-Fi.';
        return;
      }
      
      final selected = hosts.length == 1
          ? hosts.first
          : await (() async {
              if (!context.mounted) return null;
              return await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E140E),
                  title: const Text('Select a room', style: TextStyle(color: Colors.amber, fontFamily: 'Pixel')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: hosts
                        .map(
                          (ip) => ListTile(
                            leading: const Icon(Icons.sports_kabaddi, color: Colors.orangeAccent),
                            title: Text(ip, style: const TextStyle(color: Colors.white)),
                            onTap: () => Navigator.pop(context, ip),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            })();
            
      if (selected != null) {
        ipController.text = selected;
        _ipEdited = true;
      }
      
      scanning.value = false;
      status.value = selected == null
          ? 'Found ${hosts.length} rooms.'
          : 'Filled Host IP: $selected';
    } catch (error) {
      scanning.value = false;
      status.value = 'Failed to scan current network: $error';
    }
  }

  void toggleReady() {
    myReady.value = !myReady.value;
    
    if (!hosting.value) {
      session.sendControl({'type': 'player_config', 'character': character.value.name});
    }
    
    session.sendControl({
      'type': 'player_ready',
      'ready': myReady.value,
      if (!hosting.value) 'character': character.value.name,
    });
    
    status.value = myReady.value ? 'You are ready.' : 'You are not ready.';
    
    if (hosting.value && myReady.value && peerReady.value) {
      _startNetworkMatch();
    }
  }

  void _startNetworkMatch() {
    session.sendControl({
      'type': 'match_start',
      'rounds': 3,
      'hostCharacter': character.value.name,
      'clientCharacter': opponentCharacter.value.name,
    });
    
    _launchNetworkMatch(player: character.value, enemy: opponentCharacter.value, host: true);
  }
}
