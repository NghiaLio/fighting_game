import 'dart:math';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/components/arrow_component.dart';
import 'package:fighting_game/game/components/fireball_component.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/game/utils/character_sprite_animations.dart';
import 'package:fighting_game/models/ai_profile.dart';
import 'package:fighting_game/models/character_skill_audio.dart';
import 'package:fighting_game/models/player_sprite_settings.dart';
import 'package:fighting_game/models/player_stats.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CharacterComponent extends PositionComponent
    with HasGameReference<FightingGame>, CollisionCallbacks {
  final CharacterType characterType;
  final double groundY;
  final bool isPlayer;
  bool facingRight;
  final double baseMaxHp;
  double maxHp;

  late PlayerStats stats;
  late PlayerSpriteSettings spriteSettings;
  CharacterSkillAudio? skillAudio;
  AiProfile? aiProfile;

  CharacterComponent? opponent;
  bool remoteControlled = false;
  bool networkReplica = false;

  double hp = 100;
  double mana = 0;
  static const double maxMana = 100;
  CharacterState _state = CharacterState.idle;

  SpriteAnimationComponent? _animComp;
  CircleComponent? _guardAura;
  void Function()? _stopSkillAudio;

  // Physics
  double _velocityX = 0;
  double _velocityY = 0;
  bool _onGround = true;

  // Control flags (set by GameControls)
  bool movingLeft = false;
  bool movingRight = false;
  bool sprinting = false;
  bool wantsJump = false;
  bool wantsAttack1 = false;
  bool wantsAttack2 = false;
  bool wantsAttack3 = false;
  bool wantsSpecial = false;

  // Action states
  bool _isAttacking = false;
  bool _hasDealtDamage = false;
  bool _hasSpawnedProjectile = false;
  double _attackTimer = 0;
  double _currentAttackDuration = 0;

  // Hurt states
  bool _isHurt = false;
  double _hurtTimer = 0;
  double _hurtDuration = 0.35;

  // Jump / Landing states
  bool _isLanding = false;
  double _landingTimer = 0;
  static const double _landingDuration = 0.18; // Allow landing frames to play out

  // Dying / Dead states
  bool _isDying = false;
  bool isDeadCompleted = false;
  double _deadTimer = 0;
  double _deadDuration = 1.1;

  bool _guarding = false;
  bool _guardDecisionMade = false;
  int _guardHits = 0;
  double _guardBreakTimer = 0;
  double _comboWindowTimer = 0;
  int _comboHits = 0;
  CharacterState? _nextComboAttack;
  bool _comboInProgress = false;
  bool _comboAction = false;
  bool _aiComboAttempted = false;
  int _lastNetworkComboShown = 0;

  // AI
  final _rng = Random();
  double _aiTimer = 0;
  double _whiffPunishTimer = 0;

  // AI Pattern Recognition Memory
  final Map<CharacterState, int> _opponentAttackHistory = {};
  CharacterState? _mostUsedOpponentAttack;
  int _totalTrackedAttacks = 0;

  // AI HP-Aware Strategy
  double _retreatTimer = 0;

  // Game Feel & VFX States (theo docs/03_vfx_and_game_feel.md)
  double _hitStopTimer = 0;
  double _damageFlashTimer = 0;
  double _sprintDustTimer = 0;

  void hitStop(double duration) {
    _hitStopTimer = duration;
  }

  CharacterState get currentAttackState => _state;

  void _recordOpponentPattern(CharacterState state) {
    _opponentAttackHistory[state] = (_opponentAttackHistory[state] ?? 0) + 1;
    _totalTrackedAttacks++;
    if (_totalTrackedAttacks % 3 == 0) {
      _mostUsedOpponentAttack = _opponentAttackHistory.entries
          .reduce((a, b) => a.value > b.value ? a : b).key;
    }
  }

  /// 0=aggro, 1=trading, 2=defensive, 3=desperation
  int _computeStrategy() {
    final myRatio = hp / maxHp;
    final opRatio = opponent != null ? opponent!.hp / opponent!.maxHp : 1.0;
    if (myRatio < 0.20) return 3;
    if (myRatio < 0.40) return 2;
    if ((myRatio - opRatio).abs() < 0.20) return 1;
    return 0;
  }

  bool _isOpponentCornered() {
    if (opponent == null) return false;
    const threshold = 200.0;
    final ox = opponent!.position.x;
    return ox <= threshold || ox >= (game.mapWidth - threshold);
  }

  bool _isSelfCornered() {
    const threshold = 180.0;
    return position.x <= threshold ||
        position.x >= (game.mapWidth - threshold);
  }

  // Scale for rendering the sprite: 128x128 pixel art scaled 2.5x -> 320x320
  static const double _scale = 2.5;

  CharacterComponent({
    required this.characterType,
    required double startX,
    required this.groundY,
    required this.isPlayer,
    required this.facingRight,
    required double maxHp,
    AiProfile? aiProfile,
  }) : baseMaxHp = maxHp,
       maxHp = maxHp * PlayerStats.fromPlayerType(characterType).healthMultiplier *
           (isPlayer ? 1 : (aiProfile?.hpMultiplier ?? 1)),
       aiProfile = aiProfile,
       super(
         position: Vector2(startX, 0),
         anchor: Anchor.bottomCenter,
         priority: 1,
       ) {
    hp = this.maxHp;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    stats = PlayerStats.fromPlayerType(characterType);
    spriteSettings = PlayerSpriteSettings.fromCharacterType(characterType);
    skillAudio = CharacterSkillAudio.fromCharacterType(characterType);

    position.y = groundY;

    // SpriteAnimationComponent has a fixed 128x128 * scale box
    _animComp = SpriteAnimationComponent(
      size: Vector2(128, 128) * _scale,
      anchor: Anchor.bottomCenter,
      position: Vector2(0, 0),
      priority: 0,
    );
    await add(_animComp!);

    // Hitbox for collision & attacks
    final hitbox = RectangleHitbox(
      size: Vector2(50, 120),
      anchor: Anchor.bottomCenter,
    );
    await add(hitbox);

    _guardAura = CircleComponent(
      radius: 64,
      position: Vector2(0, -76),
      anchor: Anchor.center,
      priority: 2,
      paint: Paint()
        ..color = const Color(0xBB43D9FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    )..renderShape = false;
    await add(_guardAura!);

    await _switchState(CharacterState.idle);
  }

  void resetCharacter({
    required double startX,
    required bool faceRight,
    AiProfile? newAiProfile,
    double startingMana = 0,
  }) {
    if (newAiProfile != null) {
      aiProfile = newAiProfile;
    }
    maxHp = baseMaxHp * stats.healthMultiplier *
        (isPlayer ? 1 : (aiProfile?.hpMultiplier ?? 1));
    hp = maxHp;
    mana = startingMana.clamp(0, maxMana).toDouble();
    position.x = startX;
    position.y = groundY;
    facingRight = faceRight;
    _velocityX = 0;
    _velocityY = 0;
    _onGround = true;
    _isAttacking = false;
    _stopSkillAudio?.call();
    _stopSkillAudio = null;
    _hasDealtDamage = false;
    _hasSpawnedProjectile = false;
    _attackTimer = 0;
    _isHurt = false;
    _hurtTimer = 0;
    _isLanding = false;
    _landingTimer = 0;
    _isDying = false;
    isDeadCompleted = false;
    _deadTimer = 0;
    _guarding = false;
    _guardDecisionMade = false;
    _guardHits = 0;
    _guardBreakTimer = 0;
    _comboWindowTimer = 0;
    _comboHits = 0;
    _nextComboAttack = null;
    _comboInProgress = false;
    _aiComboAttempted = false;
    _lastNetworkComboShown = 0;
    _aiTimer = 0;
    _whiffPunishTimer = 0;
    _opponentAttackHistory.clear();
    _mostUsedOpponentAttack = null;
    _totalTrackedAttacks = 0;
    _retreatTimer = 0;
    movingLeft = false;
    movingRight = false;
    sprinting = false;
    wantsJump = false;
    wantsAttack1 = false;
    wantsAttack2 = false;
    wantsAttack3 = false;
    wantsSpecial = false;
    _switchState(CharacterState.idle, forceReset: true);
  }

  Future<void> _switchState(CharacterState newState, {bool forceReset = false}) async {
    if (!forceReset && _state == newState && _animComp?.animation != null) return;
    _state = newState;

    final setting = spriteSettings.getSettingsForState(newState);
    // Only continuous loops are idle, walk, and run
    final isLoop = newState == CharacterState.idle ||
        newState == CharacterState.walk ||
        newState == CharacterState.run;

    final anim = getPlayerAnimation(
      characterType: characterType,
      characterState: newState,
      stepTime: setting.time,
      loop: isLoop,
    );

    _animComp?.animation = anim;

    final totalDur = anim.frames.fold<double>(0.0, (sum, f) => sum + f.stepTime);

    if (newState == CharacterState.hurt) {
      _hurtDuration = totalDur;
      _hurtTimer = _hurtDuration;
      _isHurt = true;
    } else if (newState == CharacterState.dead) {
      _deadDuration = totalDur + 0.3; // Extra pause on final corpse frame
      _deadTimer = 0;
      _isDying = true;
    } else if (!isLoop && newState != CharacterState.jump) {
      _currentAttackDuration = totalDur;
      _attackTimer = _currentAttackDuration;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDeadCompleted) return;

    if (!game.isNetworkMatch || game.networkHost) {
      mana = (mana + 2 * dt).clamp(0, maxMana).toDouble();
    }
    if (_comboWindowTimer > 0) {
      _comboWindowTimer -= dt;
      if (_comboWindowTimer <= 0) {
        _comboWindowTimer = 0;
        _nextComboAttack = null;
        _comboInProgress = false;
        _aiComboAttempted = false;
        _comboHits = 0;
      }
    }
    if (_whiffPunishTimer > 0) _whiffPunishTimer -= dt;

    // C. Cơ chế Khựng khung hình (Hit-Stop / Freeze Frame) theo docs/03_vfx_and_game_feel.md
    if (_hitStopTimer > 0) {
      _hitStopTimer -= dt;
      return;
    }

    // B. Hiệu ứng nhấp nháy khi bị thương (Damage Flash)
    _updateDamageFlash(dt);

    // F. Hiệu ứng bụi bứt tốc chạy (Sprint Dust)
    _updateSprintDust(dt);

    if (_isDying) {
      _handleDying(dt);
      _applyPhysics(dt);
      _flipSprite();
      _clampToScreen();
      return;
    }

    // Đứng yên trong thời gian hiện round banner
    if (game.isIntroPlaying) return;

    if (networkReplica) {
      _flipSprite();
      _guardAura?.renderShape = _guarding;
      return;
    }

    if (remoteControlled || isPlayer) {
      _handlePlayerInput(dt);
    } else {
      if (aiProfile != null) {
        _handleAI(dt, aiProfile!);
      } else {
        _velocityX = 0;
      }
    }

    _applyPhysics(dt);
    _updateAttack(dt);
    _updateHurt(dt);
    _updateLanding(dt);
    _guardAura?.renderShape = _guarding;
    _flipSprite();
    _clampToScreen();
  }

  bool get isDead => hp <= 0;
  String get networkState => _state.name;
  int get comboHits => _comboHits;
  bool get _opponentIsAttacking => opponent?._isAttacking ?? false;

  void applyRemoteInput({
    required bool left,
    required bool right,
    required bool sprint,
    int action = 0,
  }) {
    movingLeft = left;
    movingRight = right;
    sprinting = sprint;
    switch (action) {
      case 1: wantsAttack1 = true; break;
      case 2: wantsAttack2 = true; break;
      case 3: wantsAttack3 = true; break;
      case 4: wantsSpecial = true; break;
      case 5: wantsJump = true; break;
    }
  }

  void applyNetworkSnapshot(
    Map<String, dynamic> snapshot, {
    bool reconcilePosition = false,
    bool syncState = true,
    bool syncDamageState = false,
    bool showDamageEffects = false,
  }) {
    final x = snapshot['x'];
    final y = snapshot['y'];
    final remoteHp = snapshot['hp'];
    final remoteMana = snapshot['mana'];
    final remoteComboHits = snapshot['comboHits'];
    final remoteFacing = snapshot['facingRight'];
    final stateName = snapshot['state'];
    if (x is num) {
      if (reconcilePosition) {
        final error = x.toDouble() - position.x;
        if (error.abs() > 24) {
          position.x += (error * 0.10).clamp(-3.0, 3.0).toDouble();
        }
      } else {
        position.x = x.toDouble();
      }
    }
    if (y is num) {
      if (reconcilePosition) {
        final error = y.toDouble() - position.y;
        if (error.abs() > 24) {
          position.y += (error * 0.10).clamp(-3.0, 3.0).toDouble();
        }
      } else {
        position.y = y.toDouble();
      }
    }
    if (remoteHp is num) {
      final oldHp = hp;
      hp = remoteHp.toDouble().clamp(0, maxHp).toDouble();
      if (showDamageEffects && hp < oldHp) {
        final damage = oldHp - hp;
        game.spawnHitSpark(Vector2(position.x, position.y - 75));
        game.spawnFloatingDamage(Vector2(position.x, position.y - 120), damage);
        game.triggerScreenShake(duration: 0.14, intensity: 3);
      }
    }
    if (remoteMana is num) {
      mana = remoteMana.toDouble().clamp(0, maxMana).toDouble();
    }
    if (remoteComboHits is int) {
      if (remoteComboHits >= 2 && remoteComboHits != _lastNetworkComboShown) {
        game.onComboHit(isPlayer, remoteComboHits);
        _lastNetworkComboShown = remoteComboHits;
      } else if (remoteComboHits < 2) {
        _lastNetworkComboShown = 0;
      }
    }
    if (syncState && remoteFacing is bool) facingRight = remoteFacing;
    if (stateName is String && (syncState || syncDamageState)) {
      for (final state in CharacterState.values) {
        final isDamageState = state == CharacterState.hurt ||
            state == CharacterState.dead;
        if (state.name == stateName &&
            (syncState || (syncDamageState && isDamageState)) &&
            state != _state) {
          _switchState(state, forceReset: true);
          _isAttacking = state == CharacterState.attack1 ||
              state == CharacterState.attack2 ||
              state == CharacterState.attack3 ||
              state == CharacterState.special;
          break;
        }
      }
    }
    // HP is authoritative. Ensure a missed/stale state field cannot leave a
    // zero-HP replica standing idle, and let the death animation finish.
    if (hp <= 0 && _state != CharacterState.dead) {
      _isAttacking = false;
      _isHurt = false;
      _switchState(CharacterState.dead, forceReset: true);
    }
  }

  void _handleDying(double dt) {
    _deadTimer += dt;
    // Friction to slow down knockback when dying
    _velocityX *= 0.9;
    if (_deadTimer >= _deadDuration && _onGround) {
      isDeadCompleted = true;
    }
  }

  void _handlePlayerInput(double dt) {
    final requestedAttack = wantsAttack1
        ? CharacterState.attack1
        : wantsAttack2
        ? CharacterState.attack2
        : wantsAttack3
        ? CharacterState.attack3
        : wantsSpecial
        ? CharacterState.special
        : null;
    wantsAttack1 = false;
    wantsAttack2 = false;
    wantsAttack3 = false;
    wantsSpecial = false;

    if (_isAttacking) {
      if (requestedAttack != null &&
          _comboWindowTimer > 0 &&
          requestedAttack == _nextComboAttack) {
        _startAttack(requestedAttack);
      }
      return;
    }
    if (_isHurt || _isLanding || isDead || _isDying) return;

    if (requestedAttack != null) {
      if (opponent != null) facingRight = opponent!.position.x >= position.x;
      _startAttack(requestedAttack);
      return;
    }

    final movingBack = (movingLeft && facingRight) ||
        (movingRight && !facingRight);
    final dist = opponent == null
        ? double.infinity
        : (opponent!.position.x - position.x).abs();
    _guarding = movingBack &&
        _opponentIsAttacking &&
        dist <= opponent!.stats.getAttackReach(CharacterState.attack1) + 30;
    if (_guarding) {
      _velocityX = 0;
      return;
    }
    _guardHits = 0;
    if (wantsJump && _onGround) {
      wantsJump = false;
      _velocityY = -stats.jumpPower;
      _onGround = false;
      _switchState(CharacterState.jump);
      return;
    }

    if (movingLeft) {
      _velocityX = sprinting ? -stats.runSpeed * 100 : -stats.walkSpeed * 100;
      facingRight = false;
      if (_onGround) {
        _switchState(sprinting ? CharacterState.run : CharacterState.walk);
      }
    } else if (movingRight) {
      _velocityX = sprinting ? stats.runSpeed * 100 : stats.walkSpeed * 100;
      facingRight = true;
      if (_onGround) {
        _switchState(sprinting ? CharacterState.run : CharacterState.walk);
      }
    } else {
      _velocityX = 0;
      if (_onGround && _state != CharacterState.idle && !_isLanding) {
        _switchState(CharacterState.idle);
      }
    }
  }

  void _handleAI(double dt, AiProfile ai) {
    if (_isAttacking) {
      if (_comboWindowTimer > 0 &&
          _nextComboAttack != null &&
          !_aiComboAttempted) {
        _aiComboAttempted = true;
        if (_rng.nextDouble() < ai.comboChance) {
          _startAttack(_nextComboAttack!);
        }
      }
      return;
    }
    if (_isHurt || _isLanding || isDead || _isDying) {
      _guarding = false;
      return;
    }
    if (opponent == null || opponent!.isDead) {
      _velocityX = 0;
      sprinting = false;
      _switchState(CharacterState.idle);
      return;
    }

    _aiTimer -= dt;
    if (_retreatTimer > 0) _retreatTimer -= dt;
    final dx = opponent!.position.x - position.x;
    final dist = dx.abs();
    final opponentIsAttacking = opponent!._isAttacking;
    final atkReach = stats.getAttackReach(CharacterState.attack1);
    final heavyReach = stats.getAttackReach(CharacterState.attack3);
    final specialReach = stats.getAttackReach(CharacterState.special);

    // HP-Aware Strategy
    final strategy = _computeStrategy();
    double effBlockChance = ai.blockChance;
    double effSpecialChance = ai.specialChance;
    double effMinDelay = ai.minThinkDelay;
    double effMaxDelay = ai.maxThinkDelay;
    double effComboChance = ai.comboChance;
    if (strategy == 3) {
      effBlockChance = 0.0;
      effSpecialChance = 1.0;
      effMinDelay = 0.05;
      effMaxDelay = 0.15;
    } else if (strategy == 2) {
      effBlockChance = (ai.blockChance * 1.6).clamp(0.0, 1.0);
      effSpecialChance = (ai.specialChance - 0.2).clamp(0.0, 1.0);
      effMinDelay = ai.minThinkDelay + 0.2;
      effMaxDelay = ai.maxThinkDelay + 0.2;
    } else if (strategy == 1) {
      effBlockChance = (ai.blockChance + 0.15).clamp(0.0, 1.0);
    }

    final favorsSpecialRange = mana >= 50 && effSpecialChance >= 0.35;
    final preferredReach = favorsSpecialRange
        ? specialReach
        : mana >= 25 && effSpecialChance >= 0.35
        ? max(atkReach, heavyReach)
        : atkReach;

    // Trading retreat
    if (_retreatTimer > 0 && strategy == 1) {
      final retreatDir = dx > 0 ? -1.0 : 1.0;
      _velocityX = retreatDir * stats.runSpeed * 80;
      facingRight = dx > 0;
      sprinting = false;
      if (_onGround) _switchState(CharacterState.run);
      return;
    }

    // 1. Guard
    if (!opponentIsAttacking) {
      _guardDecisionMade = false;
      _guarding = false;
    } else if (!_guardDecisionMade && dist <= atkReach + 30) {
      _guardDecisionMade = true;
      _guarding = _rng.nextDouble() < effBlockChance;
    }
    if (_guarding) {
      _velocityX = 0;
      sprinting = false;
      facingRight = dx > 0;
      return;
    }

    // 2a. Pattern Counter
    final mostUsed = _mostUsedOpponentAttack;
    if (mostUsed != null &&
        (_opponentAttackHistory[mostUsed] ?? 0) >= 3 &&
        opponentIsAttacking &&
        opponent!._state == mostUsed) {
      final counterChance = (effBlockChance + 0.30).clamp(0.0, 1.0);
      if (_onGround && _rng.nextDouble() < counterChance) {
        _velocityY = -stats.jumpPower;
        _onGround = false;
        _switchState(CharacterState.jump);
        return;
      }
    }

    // 2b. Jump dodge
    if (_onGround && _rng.nextDouble() < ai.jumpChance * dt) {
      if (opponentIsAttacking || opponent!.position.y < position.y - 20) {
        _velocityY = -stats.jumpPower * 0.95;
        _onGround = false;
        _switchState(CharacterState.jump);
        return;
      }
    }

    // 2c. Corner Escape
    if (_isSelfCornered() && _onGround && _rng.nextDouble() < 0.65) {
      _velocityY = -stats.jumpPower * 1.05;
      _velocityX = (dx > 0 ? -1 : 1) * stats.runSpeed * 70;
      _onGround = false;
      _switchState(CharacterState.jump);
      return;
    }

    // Corner Pressure
    final opponentCornered = _isOpponentCornered();
    if (opponentCornered) {
      effComboChance = (effComboChance + 0.25).clamp(0.0, 1.0);
      effMinDelay *= 0.65;
      effMaxDelay *= 0.65;
    }

    // 3. Movement
    if (dist > preferredReach && dist > ai.runThreshold) {
      _velocityX = (dx > 0 ? 1 : -1) * stats.runSpeed * 100;
      facingRight = dx > 0;
      sprinting = true;
      movingLeft = dx < 0;
      movingRight = dx > 0;
      if (_onGround) _switchState(CharacterState.run);
    } else if (dist > preferredReach || dist > atkReach) {
      _velocityX = (dx > 0 ? 1 : -1) * stats.walkSpeed * 100;
      facingRight = dx > 0;
      sprinting = false;
      movingLeft = dx < 0;
      movingRight = dx > 0;
      if (dist > preferredReach || _aiTimer > 0) {
        if (_onGround) _switchState(CharacterState.walk);
      } else if (_onGround) {
        _aiTimer = effMinDelay +
            _rng.nextDouble() * (effMaxDelay - effMinDelay);
        if (opponent!._whiffPunishTimer > 0) {
          _startAttack(CharacterState.attack1);
        } else if (favorsSpecialRange && dist <= specialReach &&
            _rng.nextDouble() < effSpecialChance) {
          _startAttack(CharacterState.special);
        } else if (mana >= 25 && dist <= heavyReach &&
            _rng.nextDouble() < effSpecialChance) {
          _startAttack(CharacterState.attack3);
        } else {
          _velocityX = (dx > 0 ? 1 : -1) * stats.walkSpeed * 100;
          _switchState(CharacterState.walk);
        }
      }
    } else if (dist > atkReach) {
      _velocityX = (dx > 0 ? 1 : -1) * stats.walkSpeed * 100;
      facingRight = dx > 0;
      sprinting = false;
      movingLeft = dx < 0;
      movingRight = dx > 0;
      if (_onGround) _switchState(CharacterState.walk);
    } else {
      // 4. Attack decision
      _velocityX = 0;
      sprinting = false;
      movingLeft = false;
      movingRight = false;
      if (_onGround) {
        if (_aiTimer <= 0) {
          _aiTimer = effMinDelay + _rng.nextDouble() * (effMaxDelay - effMinDelay);

          final randSkill = _rng.nextDouble();
          if (opponent!._whiffPunishTimer > 0) {
            _startAttack(CharacterState.attack1);
          } else if (mana >= 50 && _rng.nextDouble() < effSpecialChance) {
            _startAttack(CharacterState.special);
          } else if (randSkill < 0.35) {
            _startAttack(CharacterState.attack1);
          } else if (randSkill < 0.65) {
            _startAttack(CharacterState.attack2);
          } else if (randSkill < 0.85 && mana >= 25) {
            _startAttack(CharacterState.attack3);
          } else {
            _startAttack(CharacterState.attack1);
          }
          if (strategy == 1 && _isAttacking) _retreatTimer = 0.4;
        } else {
          _switchState(CharacterState.idle);
        }
      }
    }
    facingRight = dx > 0;
  }

  void _applyPhysics(double dt) {
    const gravity = 800.0;
    if (!_onGround) {
      _velocityY += gravity * dt;
    }
    position.x += _velocityX * dt;
    position.y += _velocityY * dt;

    if (position.y >= groundY) {
      position.y = groundY;
      _velocityY = 0;
      final wasInAir = !_onGround;
      _onGround = true;

      // When touching down from a jump, smoothly complete the landing frames
      if (wasInAir && _state == CharacterState.jump && !_isDying) {
        _isLanding = true;
        _landingTimer = _landingDuration;
        _velocityX = 0;
        // F. Hiệu Ứng Bụi Tiếp Đất (Dust Particles)
        game.spawnDustPuff(Vector2(position.x, groundY));
      }
    }
  }

  void _updateLanding(double dt) {
    if (!_isLanding) return;
    _landingTimer -= dt;
    if (_landingTimer <= 0) {
      _isLanding = false;
      if (!isDead && _onGround) {
        _switchState(CharacterState.idle);
      }
    }
  }

  void _startAttack(CharacterState attackState) {
    final cost = switch (attackState) {
      CharacterState.attack3 => 25.0,
      CharacterState.special => 50.0,
      _ => 0.0,
    };
    if (mana < cost) return;

    _comboAction = _comboWindowTimer > 0 &&
        _nextComboAttack == attackState;
    if (_comboAction) {
      _comboWindowTimer = 0;
      _nextComboAttack = null;
    } else {
      _comboInProgress = attackState == CharacterState.attack1;
      _comboHits = 0;
      _nextComboAttack = null;
      _comboWindowTimer = 0;
    }
    mana = (mana - cost).clamp(0, maxMana).toDouble();
    _isAttacking = true;
    _hasDealtDamage = false;
    _hasSpawnedProjectile = false;
    _velocityX = 0;
    _switchState(attackState, forceReset: true);

    final sfx = skillAudio?.getSfxForState(attackState);
    if (sfx != null) {
      AudioService.playSkillSfx(sfx, volumeMultiplier: isPlayer ? 1.0 : 0.65).then((stopFn) {
        if (_isAttacking) {
          _stopSkillAudio = stopFn;
        } else {
          stopFn?.call();
        }
      });
    }
  }

  void _updateAttack(double dt) {
    if (!_isAttacking) return;
    _attackTimer -= dt;

    // Fire Wizard Special spawns a real projectile at apex of cast
    if (_state == CharacterState.special &&
        characterType == CharacterType.fireWizard &&
        !_hasSpawnedProjectile &&
        _attackTimer <= _currentAttackDuration * 0.55) {
      _hasSpawnedProjectile = true;
      _spawnFireball();
    }

    // Archer Special spawns a fast arrow projectile
    if (_state == CharacterState.special &&
        (characterType == CharacterType.skeletonArcher ||
         characterType == CharacterType.samuraiArcher) &&
        !_hasSpawnedProjectile &&
        _attackTimer <= _currentAttackDuration * 0.5) {
      _hasSpawnedProjectile = true;
      _spawnArrow();
    }

    // Trigger melee/sweep damage at the apex of attack
    if (!_hasDealtDamage && _attackTimer <= _currentAttackDuration / 2) {
      _tryDealDamage();
    }

    if (_attackTimer <= 0) {
      _isAttacking = false;
      _attackTimer = 0;
      if (!_hasDealtDamage && _state != CharacterState.special) {
        _whiffPunishTimer = 0.6;
        _comboInProgress = false;
        _comboHits = 0;
        _nextComboAttack = null;
        _comboWindowTimer = 0;
      }
      _switchState(CharacterState.idle);
    }
  }

  void _spawnFireball() {
    if (parent == null || opponent == null) return;
    final spawnX = position.x + (facingRight ? 45.0 : -45.0);
    final spawnY = position.y - 75.0;

    final multiplier = !isPlayer && aiProfile != null
        ? aiProfile!.damageMultiplier
        : 1.0;

    final fireball = FireballComponent(
      caster: this,
      target: opponent!,
      startPos: Vector2(spawnX, spawnY),
      facingRight: facingRight,
      damage: stats.getAttackPower(CharacterState.special) * 8.0 * multiplier,
    );
    if (game.isNetworkMatch && game.networkHost) {
      game.publishProjectile(x: spawnX, y: spawnY, facingRight: facingRight);
    }
    parent!.add(fireball);
  }

  void _spawnArrow() {
    if (parent == null || opponent == null) return;
    final spawnX = position.x + (facingRight ? 45.0 : -45.0);
    final spawnY = position.y - 75.0;

    final multiplier = !isPlayer && aiProfile != null
        ? aiProfile!.damageMultiplier
        : 1.0;

    final arrow = ArrowComponent(
      caster: this,
      target: opponent!,
      startPos: Vector2(spawnX, spawnY),
      facingRight: facingRight,
      damage: stats.getAttackPower(CharacterState.special) * 7.0 * multiplier,
    );
    parent!.add(arrow);
  }

  void _tryDealDamage() {
    if (!game.canResolveCombat) return;
    if (opponent == null || opponent!.isDead) return;

    // Fire Wizard special damage is dealt upon projectile impact
    if (_state == CharacterState.special &&
        (characterType == CharacterType.fireWizard ||
         characterType == CharacterType.skeletonArcher ||
         characterType == CharacterType.samuraiArcher)) {
      return;
    }

    final forwardDistance =
        (opponent!.position.x - position.x) * (facingRight ? 1 : -1);

    // Check reach dynamically per character archetype from PlayerStats
    final reach = stats.getAttackReach(_state);

    double multiplier = 3;
    switch (_state) {
      case CharacterState.attack1:
        multiplier = 3;
        break;
      case CharacterState.attack2:
        multiplier = 4;
        break;
      case CharacterState.attack3:
        multiplier = 6;
        break;
      case CharacterState.special:
        multiplier = 8;
        break;
      default:
        break;
    }

    if (forwardDistance >= -20 && forwardDistance <= reach) {
      _hasDealtDamage = true;
      final normalHit = _state == CharacterState.attack1 ||
          _state == CharacterState.attack2 ||
          _state == CharacterState.attack3;
      if (normalHit && (!game.isNetworkMatch || game.networkHost)) {
        mana = (mana + 10).clamp(0, maxMana).toDouble();
      }

      if (_state == CharacterState.attack1) {
        _comboHits = 1;
        _comboInProgress = true;
        _nextComboAttack = CharacterState.attack2;
        _comboWindowTimer = 0.2;
        _aiComboAttempted = false;
      } else if (_comboAction && _state == CharacterState.attack2) {
        _comboHits = 2;
        _nextComboAttack = CharacterState.attack3;
        _comboWindowTimer = 0.2;
        _aiComboAttempted = false;
      } else if (_comboAction && _state == CharacterState.attack3) {
        _comboHits = 3;
        _nextComboAttack = CharacterState.special;
        _comboWindowTimer = 0.2;
        _aiComboAttempted = false;
        opponent!.applyComboHitStun();
      } else {
        _comboHits = 1;
        _comboInProgress = false;
        _nextComboAttack = null;
        _comboWindowTimer = 0;
      }
      if (_comboHits >= 2) game.onComboHit(isPlayer, _comboHits);
      
      final dmg = stats.getAttackPower(_state) * multiplier *
          (!isPlayer && aiProfile != null
              ? aiProfile!.damageMultiplier
              : 1.0);
      final isHeavy = _state == CharacterState.attack3 || _state == CharacterState.special;

      // A. Hiệu ứng tia lửa va chạm (Hit Sparks) tại điểm tiếp xúc vũ khí
      final sparkX = (position.x + opponent!.position.x) / 2;
      final sparkY = position.y - 75.0;
      game.spawnHitSpark(Vector2(sparkX, sparkY), isHeavy: isHeavy);

      // C. Cơ chế Khựng khung hình (Hit-Stop) 0.06s cho cả 2 bên (mục C)
      hitStop(0.06);
      opponent!.hitStop(0.06);

      // D. Rung chấn màn hình (Screen Shake) (mục D)
      game.triggerScreenShake(
        duration: isHeavy ? 0.22 : 0.14,
        intensity: isHeavy ? 6.0 : 3.0,
      );

      // E. Số sát thương nảy lên (Floating Damage Numbers) (mục E)
      final damageY = opponent!.position.y - 120.0;
      game.spawnFloatingDamage(
        Vector2(opponent!.position.x, damageY),
        dmg,
        isCritical: isHeavy,
      );

      opponent!.receiveDamage(dmg);
    }
  }

  void receiveDamage(double dmg) {
    if (isDead) return;

    mana = (mana + 5).clamp(0, maxMana).toDouble();

    if (!isPlayer && opponent != null) {
      final opState = opponent!._state;
      if (opState == CharacterState.attack1 ||
          opState == CharacterState.attack2 ||
          opState == CharacterState.attack3 ||
          opState == CharacterState.special) {
        _recordOpponentPattern(opState);
      }
    }

    if (_guarding) {
      _guardHits++;
      if (_guardHits <= 4) {
        final guardedDamage = dmg * 0.2 / stats.attackResistance;
        hp = (hp - guardedDamage).clamp(0, maxHp).toDouble();
        _velocityX = (facingRight ? -1 : 1) * 24;
        if (hp <= 0) {
          _guarding = false;
          _switchState(CharacterState.dead, forceReset: true);
        }
        return;
      }
      _guarding = false;
      _guardHits = 0;
      _guardBreakTimer = 1.2;
    }
    dmg /= stats.attackResistance;
    
    if (_isAttacking) {
      _stopSkillAudio?.call();
      _stopSkillAudio = null;
    }

    hp = (hp - dmg).clamp(0, maxHp).toDouble();
    _isAttacking = false;
    _attackTimer = 0;
    _isLanding = false;

    // B. Hiệu ứng nhấp nháy khi bị thương (Damage Flash trắng trong 0.08s)
    _damageFlashTimer = 0.08;

    // Small knockback when hit
    _velocityX = (facingRight ? -1 : 1) * 90;

    if (hp <= 0) {
      _isHurt = false;
      _switchState(CharacterState.dead, forceReset: true);
    } else {
      _switchState(CharacterState.hurt, forceReset: true);
      if (_guardBreakTimer > 0) {
        _hurtTimer = _guardBreakTimer;
        _hurtDuration = _guardBreakTimer;
        _guardBreakTimer = 0;
      }
    }
  }

  void applyComboHitStun() {
    if (isDead) return;
    _isAttacking = false;
    _attackTimer = 0;
    _isLanding = false;
    _isHurt = true;
    _hurtDuration = 0.45;
    _hurtTimer = _hurtDuration;
    _velocityX = (facingRight ? -1 : 1) * 55;
    _switchState(CharacterState.hurt, forceReset: true);
  }

  void _updateHurt(double dt) {
    if (!_isHurt) return;
    _hurtTimer -= dt;
    // Gradually dampen knockback
    _velocityX *= 0.85;

    if (_hurtTimer <= 0) {
      _isHurt = false;
      _velocityX = 0;
      if (!isDead) {
        _switchState(CharacterState.idle);
      }
    }
  }

  void _flipSprite() {
    if (_animComp == null) return;
    _animComp!.scale = Vector2(facingRight ? 1 : -1, 1);
  }

  void _clampToScreen() {
    // Safe margin prevents character from ever being obscured by UI controls:
    // Left D-pad extends ~135px -> 150px safe padding
    // Right MOBA buttons extend ~135px -> 150px safe padding
    const safeMargin = 150.0;
    final minX = safeMargin;
    final maxX = game.mapWidth > 0 ? (game.mapWidth - safeMargin) : (game.size.x - safeMargin);
    position.x = position.x.clamp(minX, maxX).toDouble();
  }

  void _updateSprintDust(double dt) {
    if (_onGround && (movingLeft || movingRight) && sprinting && !_isAttacking && !_isHurt && !isDead) {
      _sprintDustTimer -= dt;
      if (_sprintDustTimer <= 0) {
        _sprintDustTimer = 0.20;
        final dustX = position.x + (facingRight ? -30.0 : 30.0);
        game.spawnDustPuff(Vector2(dustX, groundY), flipHorizontal: !facingRight);
      }
    } else {
      _sprintDustTimer = 0;
    }
  }

  void _updateDamageFlash(double dt) {
    if (_damageFlashTimer > 0) {
      _damageFlashTimer -= dt;
      if (_damageFlashTimer <= 0) {
        _animComp?.paint = Paint();
      } else {
        _animComp?.paint = Paint()
          ..colorFilter = const ColorFilter.mode(
            Colors.white,
            BlendMode.srcATop,
          );
      }
    }
  }
}
