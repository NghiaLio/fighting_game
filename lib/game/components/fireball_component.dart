import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/game/components/character_component.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// A flying fireball projectile launched by the Fire Wizard's Special skill.
class FireballComponent extends PositionComponent with HasGameReference {
  final CharacterComponent caster;
  final CharacterComponent target;
  final bool facingRight;
  final double damage;

  static const double _speed = 460.0;
  static const double _maxRange = 520.0;
  static const double _explodeDuration = 7 * 0.06;
  double _traveledDistance = 0;
  double _explodeTimer = 0;
  bool _isExploding = false;

  SpriteAnimationComponent? _animComp;
  late SpriteAnimation _flyAnim;
  late SpriteAnimation _explodeAnim;

  FireballComponent({
    required this.caster,
    required this.target,
    required Vector2 startPos,
    required this.facingRight,
    required this.damage,
  }) : super(
         position: startPos,
         size: Vector2(80, 80),
         anchor: Anchor.center,
         priority: 2,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = Flame.images.fromCache(AppAssets.fireballProjectile);

    // Flying animation: frames 0 to 4 (spinning fireball)
    final flySprites = List.generate(
      5,
      (i) => Sprite(
        image,
        srcPosition: Vector2(i * 64.0, 0),
        srcSize: Vector2(64, 64),
      ),
    );
    _flyAnim = SpriteAnimation.spriteList(
      flySprites,
      stepTime: 0.08,
      loop: true,
    );

    // Exploding animation: frames 5 to 11 (fire burst upon impact)
    final explodeSprites = List.generate(
      7,
      (i) => Sprite(
        image,
        srcPosition: Vector2((5 + i) * 64.0, 0),
        srcSize: Vector2(64, 64),
      ),
    );
    _explodeAnim = SpriteAnimation.spriteList(
      explodeSprites,
      stepTime: 0.06,
      loop: false,
    );

    _animComp = SpriteAnimationComponent(
      animation: _flyAnim,
      size: Vector2(80, 80),
      anchor: Anchor.center,
      position: Vector2(40, 40),
    );

    // Flip horizontally if firing towards the left
    if (!facingRight) {
      _animComp!.scale = Vector2(-1, 1);
    }

    await add(_animComp!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isExploding) {
      _explodeTimer += dt;
      if (_explodeTimer >= _explodeDuration) {
        removeFromParent();
      }
      return;
    }

    // Move forward
    final delta = _speed * dt;
    position.x += facingRight ? delta : -delta;
    _traveledDistance += delta;

    // Check hit target
    final dx = (target.position.x - position.x).abs();
    // Hitbox detection: target height is roughly 120px tall on ground
    final dy = (target.position.y - position.y).abs();

    if (dx < 45 && dy < 90 && !target.isDead) {
      _triggerExplosion(hitTarget: true);
      return;
    }

    // Fizzle out if max range is reached
    if (_traveledDistance >= _maxRange) {
      _triggerExplosion(hitTarget: false);
    }
  }

  void _triggerExplosion({required bool hitTarget}) {
    if (_isExploding) return;
    _isExploding = true;

    if (hitTarget) {
      // Spawn Hit Sparks, Screen Shake, and Floating Damage
      caster.game.spawnHitSpark(position, isHeavy: true);
      caster.game.triggerScreenShake(duration: 0.22, intensity: 6.0);
      final damageY = target.position.y - 120.0;
      caster.game.spawnFloatingDamage(
        Vector2(target.position.x, damageY),
        damage,
        isCritical: true,
      );
      target.receiveDamage(damage);
    }

    _animComp?.animation = _explodeAnim;
    _animComp?.size = Vector2(96, 96);
    _animComp?.position = Vector2(40, 40);
  }
}
