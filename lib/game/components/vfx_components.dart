import 'dart:math';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

/// Hiệu ứng tia lửa va chạm (Hit Sparks / Slash FX) theo mục A trong docs/03_vfx_and_game_feel.md
/// Bùng nổ tại điểm va chạm giữa vũ khí và cơ thể đối thủ trong 0.15s - 0.2s rồi tự hủy
class HitSparkComponent extends SpriteAnimationComponent
    with HasGameReference<FightingGame> {
  final bool isHeavy;

  HitSparkComponent({
    required Vector2 position,
    this.isHeavy = false,
  }) : super(
          position: position,
          size: isHeavy ? Vector2(140, 140) : Vector2(105, 105),
          anchor: Anchor.center,
          priority: 5,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = Flame.images.fromCache('sfx/hit_spark.png');

    final sprites = List.generate(
      5,
      (i) => Sprite(
        image,
        srcPosition: Vector2(i * 128.0, 0),
        srcSize: Vector2(128, 128),
      ),
    );

    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.035,
      loop: false,
    );
  }
}

/// Hiệu ứng bụi cuộn tiếp đất & bứt tốc (Dust Particles) theo mục F trong docs/03_vfx_and_game_feel.md
/// Bốc lên từ mặt đất dưới chân nhân vật trong 0.2s rồi tan biến
class DustPuffComponent extends SpriteAnimationComponent
    with HasGameReference<FightingGame> {
  final bool flipHorizontal;

  DustPuffComponent({
    required Vector2 position,
    this.flipHorizontal = false,
  }) : super(
          position: position,
          size: Vector2(72, 72),
          anchor: Anchor.bottomCenter,
          priority: 1,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = Flame.images.fromCache('sfx/dust_puff.png');

    final sprites = List.generate(
      4,
      (i) => Sprite(
        image,
        srcPosition: Vector2(i * 128.0, 0),
        srcSize: Vector2(128, 128),
      ),
    );

    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.05,
      loop: false,
    );

    if (flipHorizontal) {
      scale = Vector2(-1, 1);
    }
  }
}

/// Số sát thương nảy lên (Floating Damage Numbers) theo mục E trong docs/03_vfx_and_game_feel.md
/// Bay vòng cung lên trên rồi mờ dần trong 0.6s
class FloatingDamageComponent extends PositionComponent
    with HasGameReference<FightingGame> {
  final double damage;
  final bool isCritical;

  static const double _lifetime = 0.60;
  double _elapsed = 0;
  final double _initialY;
  final double _vx;

  FloatingDamageComponent({
    required Vector2 position,
    required this.damage,
    this.isCritical = false,
  })  : _initialY = position.y,
        _vx = (Random().nextDouble() - 0.5) * 35.0,
        super(
          position: position,
          anchor: Anchor.center,
          priority: 8,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= _lifetime) {
      removeFromParent();
      return;
    }

    // Bay lên cao ~40px theo đường cong mượt
    final progress = (_elapsed / _lifetime).clamp(0.0, 1.0);
    final rise = sin(progress * pi * 0.5) * 42.0;

    position.y = _initialY - rise;
    position.x += _vx * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = (_elapsed / _lifetime).clamp(0.0, 1.0);
    final opacity = progress > 0.6 ? ((1.0 - progress) / 0.4).clamp(0.0, 1.0) : 1.0;

    final text = isCritical ? '-${damage.toInt()} CRIT!' : '-${damage.toInt()}';
    final fontSize = isCritical ? 18.0 : 14.0;

    // 1. Viền chữ đen đậm
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.black.withValues(alpha: opacity);

    final strokeSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        foreground: strokePaint,
        fontFamily: 'monospace',
      ),
    );

    final strokePainter = TextPainter(
      text: strokeSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(-strokePainter.width / 2, -strokePainter.height / 2);
    strokePainter.paint(canvas, offset);

    // 2. Màu chữ nổi rực rỡ (Vàng cam cho Critical, Trắng sáng cho đánh thường)
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = (isCritical ? const Color(0xFFFFB300) : Colors.white)
          .withValues(alpha: opacity);

    final fillSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        foreground: fillPaint,
        fontFamily: 'monospace',
      ),
    );

    final fillPainter = TextPainter(
      text: fillSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    fillPainter.paint(canvas, offset);
  }
}
