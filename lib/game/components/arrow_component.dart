import 'package:fighting_game/game/components/character_component.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ArrowComponent extends PositionComponent
    with HasGameReference<FightingGame> {
  final CharacterComponent caster;
  final CharacterComponent target;
  final bool facingRight;
  final double damage;

  static const double _speed = 620.0;
  static const double _maxRange = 580.0;
  double _traveledDistance = 0;
  bool _hit = false;

  ArrowComponent({
    required this.caster,
    required this.target,
    required Vector2 startPos,
    required this.facingRight,
    required this.damage,
  }) : super(
          position: startPos,
          size: Vector2(32, 8),
          anchor: Anchor.center,
          priority: 2,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (_hit) return;

    final delta = _speed * dt;
    position.x += facingRight ? delta : -delta;
    _traveledDistance += delta;

    final dx = (target.position.x - position.x).abs();
    final dy = (target.position.y - position.y).abs();

    if (dx < 40 && dy < 80 && !target.isDead) {
      _triggerHit();
      return;
    }

    if (_traveledDistance >= _maxRange) {
      _hit = true;
      removeFromParent();
    }
  }

  void _triggerHit() {
    _hit = true;
    if (game.canResolveCombat) {
      game.spawnHitSpark(position, isHeavy: false);
      game.triggerScreenShake(duration: 0.10, intensity: 2.0);
      final damageY = target.position.y - 120.0;
      game.spawnFloatingDamage(
        Vector2(target.position.x, damageY),
        damage,
      );
      target.receiveDamage(damage);
    }
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();
    if (!facingRight) {
      canvas.translate(size.x, 0);
      canvas.scale(-1, 1);
    }
    final shaftPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..strokeWidth = 3.0;
    canvas.drawLine(const Offset(0, 4), const Offset(24, 4), shaftPaint);
    final headPaint = Paint()
      ..color = const Color(0xFFC0C0C0)
      ..style = PaintingStyle.fill;
    final headPath = Path()
      ..moveTo(24, 1)
      ..lineTo(32, 4)
      ..lineTo(24, 7)
      ..close();
    canvas.drawPath(headPath, headPaint);
    final fletchPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.0;
    canvas.drawLine(const Offset(0, 4), const Offset(4, 1), fletchPaint);
    canvas.drawLine(const Offset(0, 4), const Offset(4, 7), fletchPaint);
    canvas.restore();
  }
}
