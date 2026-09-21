import 'package:fighting_game/game/components/character_component.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HudComponent extends Component with HasGameReference<FightingGame> {
  final CharacterComponent player;
  final CharacterComponent enemy;

  // Timer
  double _matchTime = 99.0;
  bool _matchOver = false;

  // Text components
  late TextComponent _timerText;
  late TextComponent _p1Label;
  late TextComponent _enemyLabel;
  late TextComponent _winText;

  HudComponent({required this.player, required this.enemy});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
    );

    final timerStyle = TextStyle(
      color: Colors.yellow,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(blurRadius: 8, color: Colors.orange)],
    );

    final winStyle = TextStyle(
      color: Colors.yellow,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 10, color: Colors.red),
        Shadow(blurRadius: 4, color: Colors.black),
      ],
    );

    _p1Label = TextComponent(
      text: 'FIRE WIZARD',
      textRenderer: TextPaint(style: labelStyle),
      position: Vector2(16, 12),
    );
    _enemyLabel = TextComponent(
      text: 'KNIGHT',
      textRenderer: TextPaint(style: labelStyle),
      position: Vector2(game.size.x - 16, 12),
      anchor: Anchor.topRight,
    );
    _timerText = TextComponent(
      text: '99',
      textRenderer: TextPaint(style: timerStyle),
      position: Vector2(game.size.x / 2, 10),
      anchor: Anchor.topCenter,
    );
    _winText = TextComponent(
      text: '',
      textRenderer: TextPaint(style: winStyle),
      position: Vector2(game.size.x / 2, game.size.y / 2 - 20),
      anchor: Anchor.center,
    );

    await addAll([_p1Label, _enemyLabel, _timerText, _winText]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _enemyLabel.position = Vector2(size.x - 16, 12);
    _timerText.position = Vector2(size.x / 2, 10);
    _winText.position = Vector2(size.x / 2, size.y / 2 - 20);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final gameSize = game.size;
    const barHeight = 14.0;
    const barY = 30.0;
    const barWidth = 160.0;
    const barPad = 16.0;
    const borderRadius = 6.0;

    // P1 health bar (left)
    _drawHealthBar(
      canvas,
      left: barPad,
      top: barY,
      width: barWidth,
      height: barHeight,
      ratio: (player.hp / player.maxHp).clamp(0, 1),
      radius: borderRadius,
      isPlayer: true,
    );

    // Enemy health bar (right)
    _drawHealthBar(
      canvas,
      left: gameSize.x - barPad - barWidth,
      top: barY,
      width: barWidth,
      height: barHeight,
      ratio: (enemy.hp / enemy.maxHp).clamp(0, 1),
      radius: borderRadius,
      isPlayer: false,
    );
  }

  void _drawHealthBar(
    Canvas canvas, {
    required double left,
    required double top,
    required double width,
    required double height,
    required double ratio,
    required double radius,
    required bool isPlayer,
  }) {
    final rrect = RRect.fromLTRBR(
      left,
      top,
      left + width,
      top + height,
      Radius.circular(radius),
    );
    // Background
    canvas.drawRRect(
      rrect,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );
    // Fill
    final fillColor = _hpColor(ratio);
    final fillWidth = width * ratio;
    final fillRRect = RRect.fromLTRBR(
      left,
      top,
      left + fillWidth,
      top + height,
      Radius.circular(radius),
    );
    canvas.drawRRect(fillRRect, Paint()..color = fillColor);
    // Border
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  Color _hpColor(double ratio) {
    if (ratio > 0.5) return const Color(0xFF44FF66);
    if (ratio > 0.25) return const Color(0xFFFFCC00);
    return const Color(0xFFFF3333);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_matchOver) return;

    _matchTime -= dt;
    if (_matchTime < 0) _matchTime = 0;
    _timerText.text = _matchTime.ceil().toString();

    // Check win condition (wait for death animation to fully finish)
    if (player.isDeadCompleted) {
      _showWin(victory: false, msg: 'ENEMY WINS!');
    } else if (enemy.isDeadCompleted) {
      _showWin(victory: true, msg: 'YOU WIN!');
    } else if (_matchTime <= 0) {
      if (player.hp > enemy.hp) {
        _showWin(victory: true, msg: 'YOU WIN!');
      } else if (enemy.hp > player.hp) {
        _showWin(victory: false, msg: 'ENEMY WINS!');
      } else {
        _showWin(victory: false, msg: 'DRAW!');
      }
    }
  }

  void _showWin({required bool victory, required String msg}) {
    if (_matchOver) return;
    _matchOver = true;
    _winText.text = msg;

    // Phát âm thanh chiến thắng / thất bại ngay trước khi hiện dialog
    AudioService.playMatchEnd(isVictory: victory);

    // Chờ giọng nói/âm thanh vang lên trước khi hiển thị dialog kết quả
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (isMounted && _matchOver) {
        game.onMatchEnd(victory: victory, message: msg);
      }
    });
  }

  void resetHud() {
    _matchTime = 99.0;
    _matchOver = false;
    _winText.text = '';
    _timerText.text = '99';
    AudioService.stopMatchEnd();
  }
}
