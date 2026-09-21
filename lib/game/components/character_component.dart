import 'dart:math';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/components/fireball_component.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/game/utils/character_sprite_animations.dart';
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
  final double maxHp;

  late PlayerStats stats;
  late PlayerSpriteSettings spriteSettings;
  CharacterSkillAudio? skillAudio;

  CharacterComponent? opponent;

  double hp = 100;
  CharacterState _state = CharacterState.idle;

  SpriteAnimationComponent? _animComp;

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

  // AI
  final _rng = Random();
  double _aiTimer = 0;

  // Game Feel & VFX States (theo docs/03_vfx_and_game_feel.md)
  double _hitStopTimer = 0;
  double _damageFlashTimer = 0;
  double _sprintDustTimer = 0;

  void hitStop(double duration) {
    _hitStopTimer = duration;
  }

  // Scale for rendering the sprite: 128x128 pixel art scaled 2.5x -> 320x320
  static const double _scale = 2.5;

  CharacterComponent({
    required this.characterType,
    required double startX,
    required this.groundY,
    required this.isPlayer,
    required this.facingRight,
    required this.maxHp,
  }) : super(
         position: Vector2(startX, 0),
         anchor: Anchor.bottomCenter,
         priority: 1,
       ) {
    hp = maxHp;
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

    await _switchState(CharacterState.idle);
  }

  void resetCharacter({required double startX, required bool faceRight}) {
    hp = maxHp;
    position.x = startX;
    position.y = groundY;
    facingRight = faceRight;
    _velocityX = 0;
    _velocityY = 0;
    _onGround = true;
    _isAttacking = false;
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
    _aiTimer = 0;
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

    if (isPlayer) {
      _handlePlayerInput(dt);
    } else {
      _handleAI(dt);
    }

    _applyPhysics(dt);
    _updateAttack(dt);
    _updateHurt(dt);
    _updateLanding(dt);
    _flipSprite();
    _clampToScreen();
  }

  bool get isDead => hp <= 0;

  void _handleDying(double dt) {
    _deadTimer += dt;
    // Friction to slow down knockback when dying
    _velocityX *= 0.9;
    if (_deadTimer >= _deadDuration && _onGround) {
      isDeadCompleted = true;
    }
  }

  void _handlePlayerInput(double dt) {
    if (_isAttacking || _isHurt || _isLanding || isDead) return;

    if (wantsAttack1) {
      wantsAttack1 = false;
      _startAttack(CharacterState.attack1);
      return;
    }
    if (wantsAttack2) {
      wantsAttack2 = false;
      _startAttack(CharacterState.attack2);
      return;
    }
    if (wantsAttack3) {
      wantsAttack3 = false;
      _startAttack(CharacterState.attack3);
      return;
    }
    if (wantsSpecial) {
      wantsSpecial = false;
      _startAttack(CharacterState.special);
      return;
    }
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

  void _handleAI(double dt) {
    if (_isAttacking || _isHurt || _isLanding || isDead) return;
    if (opponent == null || opponent!.isDead) {
      _velocityX = 0;
      _switchState(CharacterState.idle);
      return;
    }

    _aiTimer -= dt;
    final dx = opponent!.position.x - position.x;
    final dist = dx.abs();

    final atkReach = stats.getAttackReach(CharacterState.attack1);
    final runThreshold = atkReach + 60.0;

    if (dist > runThreshold) {
      // Dash / Run towards player when far away
      _velocityX = (dx > 0 ? 1 : -1) * stats.runSpeed * 100;
      facingRight = dx > 0;
      if (_onGround) _switchState(CharacterState.run);
    } else if (dist > atkReach) {
      // Walk when getting closer into attack range
      _velocityX = (dx > 0 ? 1 : -1) * stats.walkSpeed * 100;
      facingRight = dx > 0;
      if (_onGround) _switchState(CharacterState.walk);
    } else {
      _velocityX = 0;
      if (_onGround) {
        if (_aiTimer <= 0) {
          _aiTimer = 0.8 + _rng.nextDouble() * 1.2;
          final r = _rng.nextInt(6);
          if (r == 0) _startAttack(CharacterState.attack1);
          if (r == 1) _startAttack(CharacterState.attack2);
          if (r == 2) _startAttack(CharacterState.attack3);
          if (r == 3) _startAttack(CharacterState.special);
          if (r == 4 && _onGround) {
            // AI occasionally jumps
            _velocityY = -stats.jumpPower * 0.9;
            _onGround = false;
            _switchState(CharacterState.jump);
          }
        } else {
          _switchState(CharacterState.idle);
        }
      }
    }
    facingRight = dx > 0;
  }

  void _applyPhysics(double dt) {
    const gravity = 1200.0;
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
    _isAttacking = true;
    _hasDealtDamage = false;
    _hasSpawnedProjectile = false;
    _velocityX = 0;
    _switchState(attackState, forceReset: true);

    // Chỉ phát âm thanh kỹ năng khi người chơi tung chiêu
    if (isPlayer) {
      final sfx = skillAudio?.getSfxForState(attackState);
      if (sfx != null) {
        AudioService.playSkillSfx(sfx);
      }
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

    // Trigger melee/sweep damage at the apex of attack
    if (!_hasDealtDamage && _attackTimer <= _currentAttackDuration / 2) {
      _tryDealDamage();
    }

    if (_attackTimer <= 0) {
      _isAttacking = false;
      _attackTimer = 0;
      _switchState(CharacterState.idle);
    }
  }

  void _spawnFireball() {
    if (parent == null || opponent == null) return;
    final spawnX = position.x + (facingRight ? 45.0 : -45.0);
    final spawnY = position.y - 75.0;

    final fireball = FireballComponent(
      caster: this,
      target: opponent!,
      startPos: Vector2(spawnX, spawnY),
      facingRight: facingRight,
      damage: stats.getAttackPower(CharacterState.special) * 8.0,
    );
    parent!.add(fireball);
  }

  void _tryDealDamage() {
    if (opponent == null || opponent!.isDead) return;

    // Fire Wizard special damage is dealt upon projectile impact
    if (_state == CharacterState.special && characterType == CharacterType.fireWizard) {
      return;
    }

    final dx = (opponent!.position.x - position.x).abs();

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

    if (dx <= reach) {
      _hasDealtDamage = true;
      final dmg = stats.getAttackPower(_state) * multiplier;
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
    hp = (hp - dmg).clamp(0, maxHp);
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
    }
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
    position.x = position.x.clamp(minX, maxX);
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
