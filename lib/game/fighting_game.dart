import 'dart:async';
import 'dart:math';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/components/background_component.dart';
import 'package:fighting_game/game/components/character_component.dart';
import 'package:fighting_game/game/components/fireball_component.dart';
import 'package:fighting_game/game/components/game_controls.dart';
import 'package:fighting_game/game/components/hud_component.dart';
import 'package:fighting_game/game/components/vfx_components.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/models/ai_profile.dart';
import 'package:fighting_game/models/network/player_input.dart';
import 'package:fighting_game/services/network/lan_match_session.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _TimedMatchSnapshot {
  final Duration receivedAt;
  final Map<String, dynamic> data;

  const _TimedMatchSnapshot(this.receivedAt, this.data);
}

class FightingGame extends FlameGame with HasCollisionDetection {
  static const double groundFraction = 0.82;
  static const double maxHp = 100.0;
  static const double mapMultiplier = 2.8; // Extended map: 2.8x screen width

  final CharacterType playerCharacter;
  final CharacterType enemyCharacter;
  final int level; // Campaign map (1..7)
  final LanMatchSession? networkSession;
  final bool networkHost;
  final AiProfile? customAiProfile;
  final bool isTrainingMode;

  FightingGame({
    this.playerCharacter = CharacterType.fireWizard,
    this.enemyCharacter = CharacterType.knight1,
    this.level = 1,
    this.networkSession,
    this.networkHost = true,
    this.customAiProfile,
    this.isTrainingMode = false,
  });

  late PositionComponent stage;
  double mapWidth = 0;
  double cameraX = 0;

  CharacterComponent? player;
  CharacterComponent? enemy;
  late HudComponent hud;

  bool isVictory = false;
  String endMessage = '';

  /// Stage map and gauntlet round are separate progression axes.
  int get mapLevel => level.clamp(1, 7).toInt();
  int currentRound = 1;
  int playerRoundWins = 0;
  int enemyRoundWins = 0;
  double _roundStartMana = 0;

  /// true: đang trong pha giới thiệu round (banner hiện) → character không được di chuyển/tấn công
  bool isIntroPlaying = true;
  bool get isNetworkMatch => networkSession != null;
  bool get canResolveCombat => !isNetworkMatch || networkHost;
  StreamSubscription<Map<String, dynamic>>? _networkSubscription;
  StreamSubscription<String>? _networkErrorSubscription;
  final Stopwatch _networkClock = Stopwatch()..start();
  final List<_TimedMatchSnapshot> _snapshotBuffer = [];
  double _networkSendTimer = 0;
  int _serverTick = 0;
  int _lastClientReconciledTick = -1;
  bool _hasInitialNetworkSnapshot = false;
  int _lastInputSequence = -1;
  bool _networkEnded = false;

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);

  static const List<String> allBackgrounds = [
    AppAssets.arenaBg1,
    AppAssets.arenaBg2,
    AppAssets.arenaBg3,
    AppAssets.arenaBg4,
    AppAssets.arenaBg5,
    AppAssets.arenaBg6,
    AppAssets.arenaBg7,
  ];

  String _getRandomBackground() {
    if (isNetworkMatch) return allBackgrounds.first;
    return allBackgrounds[mapLevel - 1];
  }

  void _changeBackground() {
    final bgList = stage.children.whereType<BackgroundComponent>().toList();
    for (var bg in bgList) {
      bg.removeFromParent();
    }
    stage.add(BackgroundComponent(mapWidth: mapWidth, assetPath: _getRandomBackground()));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    currentRound = 1;

    // Cache all dynamic character states and control assets
    const states = [
      'Idle.png',
      'Walk.png',
      'Run.png',
      'Jump.png',
      'Attack_1.png',
      'Attack_2.png',
      'Attack_3.png',
      'Special.png',
      'Hurt.png',
      'Dead.png',
    ];

    final toLoad = <String>[
      ...allBackgrounds,
      ...AppAssets.battleControls,
      AppAssets.hitSpark,
      AppAssets.dustPuff,
      AppAssets.vfxWin,
      AppAssets.vfxLose,
    ];

    for (final s in states) {
      toLoad.add(AppAssets.characterStateFlamePath(playerCharacter.spritePath, s));
      toLoad.add(AppAssets.characterStateFlamePath(enemyCharacter.spritePath, s));
    }

    if (playerCharacter == CharacterType.fireWizard ||
        enemyCharacter == CharacterType.fireWizard) {
      toLoad.add(AppAssets.fireballProjectile);
    }

    await Flame.images.loadAll(toLoad.toSet().toList());

    mapWidth = size.x * mapMultiplier;

    // Stage contains all in-world objects (Background, Player, Enemy)
    // Offset by cameraX so camera follows player smoothly
    stage = PositionComponent(priority: 0);
    await add(stage);

    await _spawnEntities(size);
    final session = networkSession;
    if (session != null) {
      _networkSubscription = session.messages.listen(_onNetworkMessage);
      _networkErrorSubscription = session.errors.listen((_) {
        if (!_networkEnded) onMatchEnd(victory: !networkHost, message: 'CONNECTION LOST');
      });
      session.startHeartbeat();
    }
  }

  Future<void> _spawnEntities(Vector2 gameSize) async {
    final groundY = gameSize.y * groundFraction;

    // 1. Add extended tiled background to stage
    await stage.add(BackgroundComponent(mapWidth: mapWidth, assetPath: _getRandomBackground()));

    // 2. Spawn Player and Enemy with comfortable fighting distance
    final localStartX = isNetworkMatch && !networkHost
        ? mapWidth * 0.55
        : mapWidth * 0.30;
    final remoteStartX = isNetworkMatch && !networkHost
        ? mapWidth * 0.30
        : mapWidth * 0.55;
    final p1 = CharacterComponent(
      characterType: playerCharacter,
      startX: localStartX,
      groundY: groundY,
      isPlayer: true,
      facingRight: networkHost || !isNetworkMatch,
      maxHp: maxHp,
    );
    await stage.add(p1);

    final enemyAiProfile = isNetworkMatch
        ? null
        : (isTrainingMode
            ? null
            : (customAiProfile ?? AiProfile.forMapAndRound(mapLevel, currentRound)));
    final e1 = CharacterComponent(
      characterType: enemyCharacter,
      startX: remoteStartX,
      groundY: groundY,
      isPlayer: false,
      facingRight: !networkHost,
      maxHp: maxHp,
      aiProfile: enemyAiProfile,
    );
    if (isNetworkMatch) {
      e1.remoteControlled = true;
      if (!networkHost) e1.networkReplica = true;
    }
    await stage.add(e1);

    p1.opponent = e1;
    e1.opponent = p1;
    player = p1;
    enemy = e1;

    // Center camera on player initially
    cameraX = (p1.position.x - gameSize.x / 2)
        .clamp(0.0, mapWidth - gameSize.x)
        .toDouble();
    stage.position.x = -cameraX;

    // 3. UI overlays (HUD & Controls) stay fixed on screen
    hud = HudComponent(player: p1, enemy: e1)..priority = 10;
    await add(hud);
    await add(GameControls(
      player: p1,
      onNetworkInput: isNetworkMatch && !networkHost
          ? (input) => networkSession!.sendRealtime(input.toPacket())
          : null,
    )..priority = 10);

    // 4. Giới thiệu round (banner + âm thanh) trước khi gameplay bắt đầu
    hud.setRound(currentRound);
    hud.startRoundIntro();
  }

  void onMatchEnd({required bool victory, required String message}) {
    if (_networkEnded) return;
    _networkEnded = true;
    if (!isNetworkMatch) {
      if (victory) {
        playerRoundWins++;
      } else {
        enemyRoundWins++;
      }
      hud.recordRoundResult(playerWon: victory);
    }
    if (isNetworkMatch && networkHost) {
      networkSession!.sendControl({
        'type': 'match_result',
        'victory': victory,
        'message': message,
      });
    }
    isVictory = victory;
    endMessage = message;
    overlays.add('GameOver');
    if (Get.isRegistered<GameMatchController>()) {
      GameMatchController.to.finishMatch(victory: victory, message: message);
    }
  }

  void restartMatch() {
    AudioService.stopMatchEnd();
    _networkEnded = false;
    isIntroPlaying = true; // khởi lại intro khi restart
    overlays.remove('GameOver');
    if (Get.isRegistered<GameMatchController>()) {
      GameMatchController.to.restartMatch();
    }
    if (player == null || enemy == null) return;
    hud.clearRoundResult(currentRound);
    player!.resetCharacter(
      startX: mapWidth * 0.30,
      faceRight: true,
      startingMana: _roundStartMana,
    );
    enemy!.resetCharacter(
      startX: mapWidth * 0.55,
      faceRight: false,
      newAiProfile: (customAiProfile ?? AiProfile.forMapAndRound(mapLevel, currentRound)),
    );
    _changeBackground();
    hud.setRound(currentRound);
    hud.startRoundIntro(); // hiện banner round sau restart
    cameraX = (player!.position.x - size.x / 2)
        .clamp(0.0, mapWidth - size.x)
        .toDouble();
    stage.position.x = -cameraX;
  }

  /// Gọi khi round banner hiện xong → bắt đầu gameplay
  void onRoundIntroDone() {
    isIntroPlaying = false;
  }

  /// Begin the next gauntlet round after a round victory.
  void startNextRound() {
    if (currentRound >= 3 || player == null || enemy == null) return;
    currentRound++;
    _roundStartMana = player!.mana * 0.5;
    AudioService.stopMatchEnd();
    isIntroPlaying = true;
    isVictory = false;
    endMessage = '';
    _networkEnded = false;
    overlays.remove('GameOver');
    if (Get.isRegistered<GameMatchController>()) {
      GameMatchController.to.restartMatch();
    }
    player!.resetCharacter(
      startX: mapWidth * 0.30,
      faceRight: true,
      startingMana: _roundStartMana,
    );
    enemy!.resetCharacter(
      startX: mapWidth * 0.55,
      faceRight: false,
      newAiProfile: (customAiProfile ?? AiProfile.forMapAndRound(mapLevel, currentRound)),
    );
    _changeBackground();
    hud.setRound(currentRound);
    hud.startRoundIntro();
    cameraX = (player!.position.x - size.x / 2)
        .clamp(0.0, mapWidth - size.x)
        .toDouble();
    stage.position.x = -cameraX;
  }

  /// Restart the selected campaign map from Round 1.
  void restartStage() {
    currentRound = 1;
    playerRoundWins = 0;
    enemyRoundWins = 0;
    _roundStartMana = 0;
    if (player == null || enemy == null) return;
    AudioService.stopMatchEnd();
    isIntroPlaying = true;
    isVictory = false;
    endMessage = '';
    _networkEnded = false;
    overlays.remove('GameOver');
    player!.resetCharacter(startX: mapWidth * 0.30, faceRight: true);
    enemy!.resetCharacter(
      startX: mapWidth * 0.55,
      faceRight: false,
      newAiProfile: (customAiProfile ?? AiProfile.forMapAndRound(mapLevel, currentRound)),
    );
    hud.resetGauntlet();
    hud.setRound(currentRound);
    hud.startRoundIntro();
    cameraX = (player!.position.x - size.x / 2)
        .clamp(0.0, mapWidth - size.x)
        .toDouble();
    stage.position.x = -cameraX;
  }

  /// Backwards-compatible call site for callers using the old round API.
  void startNewLevel(int newRound) => startNextRound();

  int computeStarRating() {
    if (player == null) return 1;
    final finalHpRatio = player!.hp / player!.maxHp;
    if (finalHpRatio > 0.7) return 3;
    if (finalHpRatio > 0.30) return 2;
    return 1;
  }

  // Screen Shake (mục D trong docs/03_vfx_and_game_feel.md)
  double _shakeTimer = 0;
  double _shakeIntensity = 0;

  void triggerScreenShake({double duration = 0.18, double intensity = 5.0}) {
    _shakeTimer = duration;
    _shakeIntensity = intensity;
  }

  void onComboHit(bool isPlayer, int hits) {
    hud.showCombo(isPlayer: isPlayer, hits: hits);
  }

  void spawnHitSpark(Vector2 pos, {bool isHeavy = false}) {
    stage.add(HitSparkComponent(position: pos, isHeavy: isHeavy));
  }

  void spawnDustPuff(Vector2 pos, {bool flipHorizontal = false}) {
    stage.add(DustPuffComponent(position: pos, flipHorizontal: flipHorizontal));
  }

  void spawnFloatingDamage(Vector2 pos, double damage, {bool isCritical = false}) {
    stage.add(FloatingDamageComponent(position: pos, damage: damage, isCritical: isCritical));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isTrainingMode && enemy != null && !enemy!.isDead) {
      enemy!.hp = (enemy!.hp + 50 * dt).clamp(0, enemy!.maxHp).toDouble();
    }
    _networkSendTimer -= dt;
    if (isNetworkMatch && !_networkEnded &&
        networkSession!.timeSinceLastPacket > const Duration(seconds: 2)) {
      onMatchEnd(victory: !networkHost, message: 'OPPONENT LEFT');
    }
    if (_networkSendTimer <= 0) {
      _networkSendTimer = 1 / 30;
      _sendNetworkSnapshot();
    }
    _applyNetworkUpdates();
    _updateCamera(dt);
    _applyShake(dt);
  }

  void _onNetworkMessage(Map<String, dynamic> message) {
    if (message['type'] == 'input' && networkHost) {
      final sequence = message['sequence'];
      if (sequence is int && sequence > _lastInputSequence) {
        _lastInputSequence = sequence;
        final action = message['action'];
        enemy?.applyRemoteInput(
          left: message['left'] == true,
          right: message['right'] == true,
          sprint: message['sprint'] == true,
          action: action is int ? action : 0,
        );
      }
    } else if (message['type'] == 'snapshot' && !networkHost) {
      _snapshotBuffer.add(_TimedMatchSnapshot(_networkClock.elapsed, message));
      if (_snapshotBuffer.length > 8) _snapshotBuffer.removeAt(0);
    } else if (message['type'] == 'projectile' && !networkHost) {
      final x = message['x'];
      final y = message['y'];
      if (x is num && y is num && enemy != null && player != null) {
        stage.add(FireballComponent(
          caster: enemy!,
          target: player!,
          startPos: Vector2(x.toDouble(), y.toDouble()),
          facingRight: message['facingRight'] == true,
          damage: 0,
        ));
      }
    } else if (message['type'] == 'match_result' && !networkHost) {
      final hostWon = message['victory'] == true;
      final isDraw = message['message'] == 'DRAW!';
      hud.showNetworkResult(
        victory: isDraw ? false : !hostWon,
        message: isDraw
            ? 'DRAW!'
            : hostWon ? 'YOU LOSE!' : 'YOU WIN!',
      );
    } else if (message['type'] == 'room_left') {
      onMatchEnd(victory: !networkHost, message: 'OPPONENT LEFT');
    }
  }

  void _applyNetworkUpdates() {
    if (!networkHost && _snapshotBuffer.isNotEmpty) {
      _applyInterpolatedSnapshot();
    }
  }

  void _applyInterpolatedSnapshot() {
    // Render slightly behind packet arrival so jitter is absorbed between
    // snapshots. Local input remains immediate and is reconciled gradually.
    final renderTime = _networkClock.elapsed - const Duration(milliseconds: 100);
    var before = _snapshotBuffer.first;
    var after = _snapshotBuffer.last;
    for (var i = 0; i < _snapshotBuffer.length; i++) {
      final snapshot = _snapshotBuffer[i];
      if (snapshot.receivedAt <= renderTime) before = snapshot;
      if (snapshot.receivedAt >= renderTime) {
        after = snapshot;
        break;
      }
    }
    final interval = after.receivedAt - before.receivedAt;
    final amount = interval.inMicroseconds == 0
        ? 1.0
        : ((renderTime - before.receivedAt).inMicroseconds /
                  interval.inMicroseconds)
              .clamp(0.0, 1.0)
              .toDouble();
    final hostState = _interpolateActor(before.data['host'], after.data['host'], amount);
    final newest = _snapshotBuffer.last;
    final clientState = newest.data['client'];
    if (hostState == null || clientState == null) return;
    final localHostState = _toLocalCoordinates(hostState, after.data);
    enemy?.applyNetworkSnapshot(localHostState, showDamageEffects: true);
    final newestTick = newest.data['serverTick'];
    if (clientState is Map<String, dynamic> &&
        newestTick is int && newestTick != _lastClientReconciledTick) {
      _lastClientReconciledTick = newestTick;
      player?.applyNetworkSnapshot(
        _toLocalCoordinates(clientState, newest.data),
        // The first authoritative packet establishes the spawn positions.
        // Later packets reconcile gently to preserve local input response.
        reconcilePosition: _hasInitialNetworkSnapshot,
        syncState: false,
        syncDamageState: true,
        showDamageEffects: true,
      );
      _hasInitialNetworkSnapshot = true;
    }
  }

  Map<String, dynamic> _toLocalCoordinates(
    Map<String, dynamic> actor,
    Map<String, dynamic> snapshot,
  ) {
    final result = Map<String, dynamic>.from(actor);
    final sourceWidth = snapshot['worldWidth'];
    final sourceGroundY = snapshot['groundY'];
    final x = actor['x'];
    final y = actor['y'];
    if (sourceWidth is num && sourceWidth > 0 && x is num) {
      result['x'] = x / sourceWidth * mapWidth;
    }
    final localGroundY = size.y * groundFraction;
    if (sourceGroundY is num && sourceGroundY > 0 && y is num) {
      result['y'] = y / sourceGroundY * localGroundY;
    }
    return result;
  }

  Map<String, dynamic>? _interpolateActor(Object? older, Object? newer, double amount) {
    if (older is! Map<String, dynamic> || newer is! Map<String, dynamic>) return null;
    final result = Map<String, dynamic>.from(amount < 0.5 ? older : newer);
    for (final key in ['x', 'y']) {
      final a = older[key];
      final b = newer[key];
      if (a is num && b is num) result[key] = a + (b - a) * amount;
    }
    return result;
  }

  void _sendNetworkSnapshot() {
    final session = networkSession;
    if (session == null || !networkHost || player == null || enemy == null) return;
    Map<String, Object?> state(CharacterComponent character) => {
      'x': character.position.x,
      'y': character.position.y,
      'hp': character.hp,
      'mana': character.mana,
      'comboHits': character.comboHits,
      'facingRight': character.facingRight,
      'state': character.networkState,
    };
    session.sendRealtime({
      'type': 'snapshot',
      'serverTick': ++_serverTick,
      'ackInputSequence': _lastInputSequence,
      'worldWidth': mapWidth,
      'groundY': size.y * groundFraction,
      'host': state(player!),
      'client': state(enemy!),
      'round': currentRound,
    });
  }

  void publishProjectile({
    required double x,
    required double y,
    required bool facingRight,
  }) {
    if (!isNetworkMatch || !networkHost) return;
    networkSession!.sendRealtime({
      'type': 'projectile',
      'x': x,
      'y': y,
      'facingRight': facingRight,
    });
  }

  @override
  void onRemove() {
    _networkSubscription?.cancel();
    _networkErrorSubscription?.cancel();
    super.onRemove();
  }

  void _applyShake(double dt) {
    if (_shakeTimer <= 0) return;
    _shakeTimer -= dt;
    final random = Random();
    final offsetX = (random.nextDouble() * 2 - 1) * _shakeIntensity;
    final offsetY = (random.nextDouble() * 2 - 1) * _shakeIntensity;
    stage.position += Vector2(offsetX, offsetY);
  }

  void _updateCamera(double dt) {
    if (player == null || mapWidth <= size.x) return;

    // Center view on player
    final targetCameraX = (player!.position.x - size.x / 2)
        .clamp(0.0, mapWidth - size.x)
        .toDouble();

    // Smooth exponential lerp
    const lerpSpeed = 6.0;
    cameraX += (targetCameraX - cameraX) * (1.0 - exp(-lerpSpeed * dt));
    cameraX = cameraX.clamp(0.0, mapWidth - size.x).toDouble();

    stage.position.x = -cameraX;
    stage.position.y = 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    mapWidth = size.x * mapMultiplier;
  }
}
