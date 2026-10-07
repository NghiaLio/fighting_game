import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/enums/character_type.dart';
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
  late TextComponent _comboText;
  double _comboTimer = 0;
  final List<bool> _playerRoundResults = List<bool>.filled(3, false);
  final List<bool> _enemyRoundResults = List<bool>.filled(3, false);
  Sprite? _winSprite;
  Sprite? _loseSprite;
  late _BannerComponent _winBanner;
  double _bannerAnimProgress = 0.0;
  bool _animatingBanner = false;

  // Round intro banner
  late _BannerComponent _roundBanner;
  late TextComponent _roundCaption;
  Sprite? _round1Sprite;
  Sprite? _round2Sprite;
  Sprite? _round3Sprite;
  double _roundAnimProgress = 0.0;
  bool _animatingRound = false;
  double _roundHoldTimer = 0.0;
  static const _roundHoldDuration = 1.8; // giây hiển thị banner

  int _currentRound = 1;

  HudComponent({required this.player, required this.enemy});

  CharacterComponent get _leftCharacter =>
      game.isNetworkMatch && !game.networkHost ? enemy : player;
  CharacterComponent get _rightCharacter =>
      game.isNetworkMatch && !game.networkHost ? player : enemy;

  String _characterName(CharacterType type) => switch (type) {
    CharacterType.fireWizard => 'FIRE WIZARD',
    CharacterType.lightningWizard => 'LIGHTNING WIZARD',
    CharacterType.wandererMagician => 'WANDERER',
    CharacterType.skeletonWarrior => 'SKELETON WARRIOR',
    CharacterType.skeletonArcher => 'SKELETON ARCHER',
    CharacterType.skeletonSpearman => 'SKELETON SPEARMAN',
    CharacterType.samurai => 'SAMURAI',
    CharacterType.samuraiArcher => 'SAMURAI ARCHER',
    CharacterType.samuraiCommander => 'SAMURAI COMMANDER',
    CharacterType.knight1 => 'KNIGHT',
    CharacterType.knight2 => 'KNIGHT 2',
    CharacterType.knight3 => 'KNIGHT 3',
  };

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
      text: game.isNetworkMatch
          ? 'HOST • ${_characterName(_leftCharacter.characterType)}'
          : _characterName(_leftCharacter.characterType),
      textRenderer: TextPaint(style: labelStyle),
      position: Vector2(16, 12),
    );
    _enemyLabel = TextComponent(
      text: game.isNetworkMatch
          ? 'CLIENT • ${_characterName(_rightCharacter.characterType)}'
          : _characterName(_rightCharacter.characterType),
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
    _comboText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD54F),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(blurRadius: 6, color: Colors.black)],
        ),
      ),
      position: Vector2(game.size.x / 2, 66),
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

    _roundCaption = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFF5252),
          fontSize: 16,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
        ),
      ),
      position: Vector2(game.size.x / 2, game.size.y / 2 + 52),
      anchor: Anchor.topCenter,
      priority: 21,
    );

    await addAll([
      _p1Label,
      _enemyLabel,
      _timerText,
      _comboText,
      _winBanner,
      _roundBanner,
      _roundCaption,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _enemyLabel.position = Vector2(size.x - 16, 12);
    _timerText.position = Vector2(size.x / 2, 10);
    _comboText.position = Vector2(size.x / 2, 66);
    _winBanner.position = Vector2(size.x / 2, size.y / 2 - 20);
    _roundBanner.position = Vector2(size.x / 2, size.y / 2);
    _roundCaption.position = Vector2(size.x / 2, size.y / 2 + 52);
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

    // In LAN matches both screens use the same world-side mapping: Host left, Client right.
    _drawHealthBar(
      canvas,
      left: barPad,
      top: barY,
      width: barWidth,
      height: barHeight,
      ratio: (_leftCharacter.hp / _leftCharacter.maxHp).clamp(0, 1).toDouble(),
      radius: borderRadius,
      isPlayer: true,
    );

    _drawManaBar(
      canvas,
      left: barPad,
      top: barY + barHeight + 3,
      width: barWidth,
      height: 7,
      ratio: (_leftCharacter.mana / CharacterComponent.maxMana)
          .clamp(0, 1)
          .toDouble(),
      rightAligned: false,
    );

    // Enemy health bar (right)
    _drawHealthBar(
      canvas,
      left: gameSize.x - barPad - barWidth,
      top: barY,
      width: barWidth,
      height: barHeight,
      ratio: (_rightCharacter.hp / _rightCharacter.maxHp).clamp(0, 1).toDouble(),
      radius: borderRadius,
      isPlayer: false,
    );
    _drawManaBar(
      canvas,
      left: gameSize.x - barPad - barWidth,
      top: barY + barHeight + 3,
      width: barWidth,
      height: 7,
      ratio: (_rightCharacter.mana / CharacterComponent.maxMana)
          .clamp(0, 1)
          .toDouble(),
      rightAligned: true,
    );
    _drawRoundBadges(canvas, left: barPad + 3,
        wins: _playerRoundResults.where((won) => won).length,
        color: const Color(0xFFFFD54F));
    _drawRoundBadges(canvas, left: gameSize.x - barPad - 42,
        wins: _enemyRoundResults.where((won) => won).length,
        color: const Color(0xFFEF5350));
  }

  void _drawManaBar(
    Canvas canvas, {
    required double left,
    required double top,
    required double width,
    required double height,
    required double ratio,
    required bool rightAligned,
  }) {
    final background = RRect.fromLTRBR(
      left, top, left + width, top + height, const Radius.circular(4),
    );
    canvas.drawRRect(background, Paint()..color = Colors.black54);
    final fillWidth = width * ratio;
    final fillLeft = rightAligned ? left + width - fillWidth : left;
    canvas.drawRRect(
      RRect.fromLTRBR(fillLeft, top, fillLeft + fillWidth, top + height,
          const Radius.circular(4)),
      Paint()..color = const Color(0xFF26D9E8),
    );
  }

  void _drawRoundBadges(
    Canvas canvas, {
    required double left,
    required int wins,
    required Color color,
  }) {
    for (var i = 0; i < 3; i++) {
      final active = i < wins;
      canvas.drawCircle(
        Offset(left + i * 15, 64),
        5,
        Paint()..color = active ? color : const Color(0xFF77716A),
      );
      canvas.drawCircle(
        Offset(left + i * 15, 64),
        5,
        Paint()
          ..color = active ? Colors.white70 : const Color(0xFFB08D57)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  void showCombo({required bool isPlayer, required int hits}) {
    if (!isLoaded || hits < 2) return;
    _comboText.text = hits >= 3
        ? '${isPlayer ? 'YOU' : 'CPU'} • COMBO FINISH!'
        : '${isPlayer ? 'YOU' : 'CPU'} • $hits HITS!';
    _comboTimer = 1.2;
  }

  void recordRoundResult({required bool playerWon}) {
    final index = (_currentRound - 1).clamp(0, 2).toInt();
    _playerRoundResults[index] = playerWon;
    _enemyRoundResults[index] = !playerWon;
  }

  void clearRoundResult(int round) {
    final index = (round - 1).clamp(0, 2).toInt();
    _playerRoundResults[index] = false;
    _enemyRoundResults[index] = false;
  }

  void resetGauntlet() {
    for (var i = 0; i < 3; i++) {
      _playerRoundResults[i] = false;
      _enemyRoundResults[i] = false;
    }
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
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _comboText.text = '';
    }

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
        _roundCaption.text = '';
        // Phát âm thanh FIGHT
        AudioService.playSkillSfx(AppAssets.fight);
        game.onRoundIntroDone();
      }
    }

    if (_matchOver) return;

    // Training mode: no timer, no win/lose conditions
    if (game.isTrainingMode) {
      _timerText.text = '--';
      return;
    }

    _matchTime -= dt;
    if (_matchTime < 0) _matchTime = 0;
    _timerText.text = _matchTime.ceil().toString();

    // A LAN client waits for the host's authoritative match result.
    if (game.isNetworkMatch && !game.networkHost) return;

    // Check win condition (wait for death animation to fully finish)
    if (player.isDeadCompleted) {
      _showWin(victory: false, msg: 'ENEMY WINS!');
    } else if (enemy.isDeadCompleted) {
      _showWin(victory: true, msg: 'YOU WIN!');
    } else if (_matchTime <= 0) {
      if (player.hp > enemy.hp) {
        _showWin(victory: true, msg: 'YOU WIN!');
      } else {
        _showWin(victory: false, msg: 'TIME OVER - DEFEAT!');
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

  /// Present the Host's authoritative result locally before opening GameOver.
  void showNetworkResult({required bool victory, required String message}) {
    if (!isLoaded || _matchOver) return;
    _animatingRound = false;
    _roundHoldTimer = 0;
    _roundBanner.isShowing = false;
    _roundBanner.scale = Vector2.all(0);
    _roundCaption.text = '';
    _showWin(victory: victory, msg: message);
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
    _currentRound = round.clamp(1, 3).toInt();
    _roundCaption.text = _currentRound == 3
        ? 'FINAL ROUND • SUDDEN DEATH'
        : '';
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
