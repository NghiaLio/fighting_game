import 'dart:math';
import 'package:fighting_game/character_sprite_animations.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/player_sprite_settings.dart';
import 'package:fighting_game/player_stats.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CharacterComponent extends PositionComponent
    with HasGameReference<FightingGame>, CollisionCallbacks {
  final CharacterType characterType;
  final double groundY;
  final bool isPlayer;
  bool facingRight;
  final double maxHp;

  late PlayerStats stats;
  late PlayerSpriteSettings spriteSettings;

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

    if (_isDying) {
      _handleDying(dt);
      _applyPhysics(dt);
      _flipSprite();
      _clampToScreen();
      return;
    }

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

    if (dist > 190) {
      // Dash / Run towards player when far away
      _velocityX = (dx > 0 ? 1 : -1) * stats.runSpeed * 100;
      facingRight = dx > 0;
      if (_onGround) _switchState(CharacterState.run);
    } else if (dist > 120) {
      // Walk when getting closer
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
    _velocityX = 0;
    _switchState(attackState, forceReset: true);
  }

  void _updateAttack(double dt) {
    if (!_isAttacking) return;
    _attackTimer -= dt;

    // Trigger damage at the apex of attack
    if (!_hasDealtDamage && _attackTimer <= _currentAttackDuration / 2) {
      _tryDealDamage();
    }

    if (_attackTimer <= 0) {
      _isAttacking = false;
      _attackTimer = 0;
      _switchState(CharacterState.idle);
    }
  }

  void _tryDealDamage() {
    if (opponent == null || opponent!.isDead) return;
    final dx = (opponent!.position.x - position.x).abs();

    // Check attack reach & power based on state
    double reach = 130;
    double multiplier = 3;

    switch (_state) {
      case CharacterState.attack1:
        reach = 130;
        multiplier = 3;
        break;
      case CharacterState.attack2:
        reach = 150;
        multiplier = 4;
        break;
      case CharacterState.attack3:
        reach = 220; // Long-range (Fire breath / spin attack)
        multiplier = 6;
        break;
      case CharacterState.special:
        reach = 260; // Ultimate skill
        multiplier = 8;
        break;
      default:
        break;
    }

    if (dx <= reach) {
      _hasDealtDamage = true;
      final dmg = stats.getAttackPower(_state) * multiplier;
      opponent!.receiveDamage(dmg);
    }
  }

  void receiveDamage(double dmg) {
    if (isDead) return;
    hp = (hp - dmg).clamp(0, maxHp);
    _isAttacking = false;
    _attackTimer = 0;
    _isLanding = false;

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
}
