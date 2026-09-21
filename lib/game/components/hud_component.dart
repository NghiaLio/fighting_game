import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/game/components/character_component.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Component hiển thị banner WIN / LOSE / ROUND trong trận đấu
class _BannerComponent extends SpriteComponent {
  bool isShowing = false;

  _BannerComponent({
    required super.sprite,
    required super.size,
    required super.position,
    required super.anchor,
    required super.scale,
    required super.priority,
  });

  @override
  void render(Canvas canvas) {
    if (!isShowing) return;
    super.render(canvas);
  }
}

// Keep old name as alias for existing usage
typedef WinBannerComponent = _BannerComponent;

class HudComponent extends Component with HasGameReference<FightingGame> {
  final CharacterComponent player;
  final CharacterComponent enemy;

  // Timer
  double _matchTime = 99.0;
  bool _matchOver = false;

  // Text components & Win/Lose banner
  late TextComponent _timerText;
  late TextComponent _p1Label;
  late TextComponent _enemyLabel;
  Sprite? _winSprite;
  Sprite? _loseSprite;
  late _BannerComponent _winBanner;
  double _bannerAnimProgress = 0.0;
  bool _animatingBanner = false;

  // Round intro banner
  late _BannerComponent _roundBanner;
  Sprite? _round1Sprite;
  Sprite? _round2Sprite;
  Sprite? _round3Sprite;
  double _roundAnimProgress = 0.0;
  bool _animatingRound = false;
  double _roundHoldTimer = 0.0;
  static const _roundHoldDuration = 1.8; // giây hiển thị banner

  int _currentRound = 1;

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

    _winSprite = await game.loadSprite(AppAssets.vfxWin);
    _loseSprite = await game.loadSprite(AppAssets.vfxLose);
    _round1Sprite = await game.loadSprite(AppAssets.round1);
    _round2Sprite = await game.loadSprite(AppAssets.round2);
    _round3Sprite = await game.loadSprite(AppAssets.round3);

    _winBanner = _BannerComponent(
      sprite: _winSprite!,
      size: Vector2(240, 120),
      position: Vector2(game.size.x / 2, game.size.y / 2 - 20),
      anchor: Anchor.center,
      scale: Vector2.all(0.0),
      priority: 15,
    );

    // Round banner: hiển thị ở giữa màn hình, tương đương kích thước win banner
    _roundBanner = _BannerComponent(
      sprite: _round1Sprite!,
      size: Vector2(280, 100),
      position: Vector2(game.size.x / 2, game.size.y / 2),
      anchor: Anchor.center,
      scale: Vector2.all(0.0),
      priority: 20, // Cao hơn winBanner
    );

    await addAll([_p1Label, _enemyLabel, _timerText, _winBanner, _roundBanner]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _enemyLabel.position = Vector2(size.x - 16, 12);
    _timerText.position = Vector2(size.x / 2, 10);
    _winBanner.position = Vector2(size.x / 2, size.y / 2 - 20);
    _roundBanner.position = Vector2(size.x / 2, size.y / 2);
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

    // ─── Win/Lose banner animation ───────────────────────────────────────
    if (_animatingBanner) {
      _bannerAnimProgress += dt * 3.5;
      if (_bannerAnimProgress >= 1.0) {
        _bannerAnimProgress = 1.0;
        _animatingBanner = false;
      }
      final scaleVal = Curves.easeOutBack.transform(_bannerAnimProgress);
      _winBanner.scale = Vector2.all(scaleVal);
    }

    // ─── Round banner animation (scale-in → hold → scale-out) ────────────
    if (_animatingRound) {
      _roundAnimProgress += dt * 4.0; // scale-in nhanh
      if (_roundAnimProgress >= 1.0) {
        _roundAnimProgress = 1.0;
        _animatingRound = false;
        _roundHoldTimer = _roundHoldDuration;
      }
      final sv = Curves.easeOutBack.transform(_roundAnimProgress);
      _roundBanner.scale = Vector2.all(sv);
    } else if (_roundHoldTimer > 0) {
      _roundHoldTimer -= dt;
      if (_roundHoldTimer <= 0) {
        // Scale-out & bắt đầu game
        _roundBanner.isShowing = false;
        _roundBanner.scale = Vector2.all(0.0);
        // Phát âm thanh FIGHT
        AudioService.playSkillSfx(AppAssets.fight);
        game.onRoundIntroDone();
      }
    }

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
    _winBanner.sprite = victory ? _winSprite! : _loseSprite!;
    _winBanner.isShowing = true;
    _bannerAnimProgress = 0.0;
    _animatingBanner = true;
    _winBanner.scale = Vector2.all(0.0);

    // Phát âm thanh chiến thắng / thất bại ngay trước khi hiện dialog
    AudioService.playMatchEnd(isVictory: victory);

    // Chờ giọng nói/âm thanh vang lên trước khi hiển thị dialog kết quả
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (isMounted && _matchOver) {
        game.onMatchEnd(victory: victory, message: msg);
      }
    });
  }

  /// Hiện round banner khi bắt đầu hoặc restart trận
  void startRoundIntro() {
    if (!isLoaded) return;
    _matchTime = 99.0;
    _matchOver = false;
    _animatingBanner = false;
    _bannerAnimProgress = 0.0;
    _winBanner.isShowing = false;
    _winBanner.scale = Vector2.all(0.0);
    _timerText.text = '99';
    AudioService.stopMatchEnd();

    // Chọn sprite đúng theo round
    final sprite = switch (_currentRound) {
      2 => _round2Sprite!,
      3 => _round3Sprite!,
      _ => _round1Sprite!,
    };

    // Phát âm thanh round
    final sfx = switch (_currentRound) {
      2 => AppAssets.sfxRound2,
      3 => AppAssets.sfxRound3,
      _ => AppAssets.sfxRound1,
    };
    AudioService.playSkillSfx(sfx);

    _roundBanner.sprite = sprite;
    _roundBanner.scale = Vector2.all(0.0);
    _roundBanner.isShowing = true;
    _roundAnimProgress = 0.0;
    _animatingRound = true;
    _roundHoldTimer = 0;
  }

  void setRound(int round) {
    _currentRound = round.clamp(1, 3);
  }

  void resetHud() {
    _matchTime = 99.0;
    _matchOver = false;
    _animatingBanner = false;
    _bannerAnimProgress = 0.0;
    _winBanner.isShowing = false;
    _winBanner.scale = Vector2.all(0.0);
    _timerText.text = '99';
    AudioService.stopMatchEnd();
  }
}
