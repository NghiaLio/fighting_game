import 'dart:math';

import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/game/components/character_component.dart';
import 'package:fighting_game/models/network/player_input.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

/// A sleek, circular MOBA-style action/control button.
class _MobaCircleButton extends PositionComponent
    with TapCallbacks, HasGameReference {
  final String imagePath;
  final double radius;
  final Color borderColor;
  final Color activeColor;
  final double iconSize;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHoldChanged;
  final ValueChanged<bool>? onDoubleTapChanged;
  final bool Function()? isAvailableProvider;
  final double manaCost;
  final double Function()? currentManaProvider;

  bool _isPressed = false;
  DateTime _lastTapTime = DateTime.fromMillisecondsSinceEpoch(0);
  Sprite? _sprite;
  double _pulseTimer = 0.0;
  double _warningFlashTimer = 0.0;

  _MobaCircleButton({
    required this.imagePath,
    required Vector2 position,
    required this.radius,
    required this.borderColor,
    required this.activeColor,
    required this.iconSize,
    this.onTap,
    this.onHoldChanged,
    this.onDoubleTapChanged,
    this.isAvailableProvider,
    this.manaCost = 0.0,
    this.currentManaProvider,
  }) : super(
         position: position,
         size: Vector2.all(radius * 2),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _sprite = Sprite(Flame.images.fromCache(imagePath));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTimer += dt;
    if (_warningFlashTimer > 0) {
      _warningFlashTimer -= dt;
      if (_warningFlashTimer < 0) _warningFlashTimer = 0;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final available = isAvailableProvider?.call() ?? true;
    if (!available) {
      _warningFlashTimer = 0.35;
      return;
    }

    _isPressed = true;
    scale = Vector2.all(0.88);

    final now = DateTime.now();
    final diff = now.difference(_lastTapTime).inMilliseconds;
    if (diff < 350) {
      onDoubleTapChanged?.call(true);
    }
    _lastTapTime = now;

    onTap?.call();
    onHoldChanged?.call(true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isPressed = false;
    scale = Vector2.all(1.0);
    onHoldChanged?.call(false);
    onDoubleTapChanged?.call(false);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _isPressed = false;
    scale = Vector2.all(1.0);
    onHoldChanged?.call(false);
    onDoubleTapChanged?.call(false);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    // Tạo cảm giác nút vật lý bị nhấn lún xuống 2.5px
    if (_isPressed) {
      canvas.translate(0, 2.5);
    }

    final center = Offset(radius, radius);
    final available = isAvailableProvider?.call() ?? true;
    final isFlashingWarning = _warningFlashTimer > 0;

    if (available) {
      // -----------------------------------------------------------
      // KHẢ DỤNG: Sáng rực rỡ với hiệu ứng hào quang lấp lánh (Glow)
      // -----------------------------------------------------------
      final pulseFactor = 0.5 + 0.5 * sin(_pulseTimer * 3.5);
      final glowAlpha = (_isPressed ? 0.45 : (0.20 + 0.16 * pulseFactor)).clamp(0.0, 1.0);
      final glowPaint = Paint()
        ..color = borderColor.withValues(alpha: glowAlpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _isPressed ? 10 : 8);
      canvas.drawCircle(center, radius + 2, glowPaint);

      // Nền bán trong suốt ánh màu chủ đạo
      final bgPaint = Paint()
        ..color = _isPressed
            ? activeColor.withValues(alpha: 0.50)
            : borderColor.withValues(alpha: 0.22);
      canvas.drawCircle(center, radius, bgPaint);

      // Vòng viền ngoài phát sáng sắc nét
      final outerRingPaint = Paint()
        ..color = (_isPressed ? activeColor : borderColor).withValues(alpha: 0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _isPressed ? 2.8 : 2.2;
      canvas.drawCircle(center, radius - 1, outerRingPaint);

      // Vòng tròn điểm nhấn bên trong
      final innerRingPaint = Paint()
        ..color = (_isPressed ? activeColor : borderColor).withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, radius - 4.5, innerRingPaint);

      // Icon sắc nét, sáng 100%
      if (_sprite != null) {
        final iconOffset = Offset(radius - iconSize / 2, radius - iconSize / 2);
        final iconPaint = Paint()..color = const Color(0xFFFFFFFF);
        _sprite!.render(
          canvas,
          position: Vector2(iconOffset.dx, iconOffset.dy),
          size: Vector2.all(iconSize),
          overridePaint: iconPaint,
        );
      }
    } else {
      // -----------------------------------------------------------
      // CHƯA ĐỦ ĐIỀU KIỆN / THIẾU NĂNG LƯỢNG: Làm mờ đi rõ rệt
      // -----------------------------------------------------------
      // Nền tối mờ
      final bgPaint = Paint()..color = const Color(0x66080B12);
      canvas.drawCircle(center, radius, bgPaint);

      // Vòng viền mờ nhạt (hoặc nhấp nháy đỏ cảnh báo khi bấm vào)
      final ringColor = isFlashingWarning
          ? Colors.redAccent.withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.16);
      final outerRingPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isFlashingWarning ? 2.2 : 1.2;
      canvas.drawCircle(center, radius - 1, outerRingPaint);

      // Vòng viền phụ mờ bên trong
      final innerRingPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.07)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawCircle(center, radius - 4.5, innerRingPaint);

      // Nếu có chi phí năng lượng: vẽ vòng cung nạp năng lượng đang tích lũy
      if (manaCost > 0 && currentManaProvider != null) {
        final currentMana = currentManaProvider!();
        final progress = (currentMana / manaCost).clamp(0.0, 1.0);
        if (progress > 0.0) {
          final progressPaint = Paint()
            ..color = borderColor.withValues(alpha: 0.60)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 2.0;
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius - 1),
            -pi / 2,
            progress * 2 * pi,
            false,
            progressPaint,
          );
        }
      }

      // Icon bị làm mờ đi rõ rệt (~22% độ rõ nét)
      if (_sprite != null) {
        final iconOffset = Offset(radius - iconSize / 2, radius - iconSize / 2);
        final iconPaint = Paint()..color = const Color(0x38FFFFFF);
        _sprite!.render(
          canvas,
          position: Vector2(iconOffset.dx, iconOffset.dy),
          size: Vector2.all(iconSize),
          overridePaint: iconPaint,
        );
      }

      // Lớp phủ tối đè lên chiêu thức chưa sẵn sàng
      final darkVeilPaint = Paint()..color = const Color(0x40000000);
      canvas.drawCircle(center, radius - 1, darkVeilPaint);
    }

    canvas.restore();
  }
}

/// MOBA-style controls: Arc layout for attacks & clean circular D-pad.
class GameControls extends Component with HasGameReference {
  final CharacterComponent player;
  final ValueChanged<PlayerInput>? onNetworkInput;

  // Directional buttons
  late _MobaCircleButton _leftBtn;
  late _MobaCircleButton _rightBtn;
  late _MobaCircleButton _jumpBtn;
  late _MobaCircleButton _runBtn;

  // MOBA Attack buttons
  late _MobaCircleButton _atk1Btn; // Main attack (Big button)
  late _MobaCircleButton _atk2Btn; // Skill 1 (Arc left)
  late _MobaCircleButton _atk3Btn; // Skill 2 (Arc top-left)
  late _MobaCircleButton _skillBtn; // Skill 3 / Ultimate (Arc top)

  bool _leftHeld = false;
  bool _rightHeld = false;
  bool _runHeld = false;
  bool _leftDashing = false;
  bool _rightDashing = false;
  int _actionPulse = 0;
  double _networkSendTimer = 0;

  GameControls({required this.player, this.onNetworkInput});

  void _pressAction(int action) {
    switch (action) {
      case 1:
        player.wantsAttack1 = true;
        break;
      case 2:
        player.wantsAttack2 = true;
        break;
      case 3:
        player.wantsAttack3 = true;
        break;
      case 4:
        player.wantsSpecial = true;
        break;
      case 5:
        player.wantsJump = true;
        break;
      default: break;
    }
    _actionPulse = action;
    _sendNetworkInput();
  }

  void _sendNetworkInput() {
    final runOnly = _runHeld && !_leftHeld && !_rightHeld;
    onNetworkInput?.call(PlayerInput(
      sequence: 0,
      left: _leftHeld || (runOnly && !player.facingRight),
      right: _rightHeld || (runOnly && player.facingRight),
      sprint: _runHeld || _leftDashing || _rightDashing,
      action: _actionPulse,
    ));
    _actionPulse = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sw = game.size.x;
    final sh = game.size.y;

    _createButtons(sw, sh);

    await addAll([
      _leftBtn,
      _rightBtn,
      _jumpBtn,
      _runBtn,
      _atk1Btn,
      _atk2Btn,
      _atk3Btn,
      _skillBtn,
    ]);
  }

  void _createButtons(double sw, double sh) {
    // -------------------------------------------------------------
    // LEFT D-PAD CLUSTER (Clean circular cluster)
    // -------------------------------------------------------------
    final dpadCenter = Vector2(110, sh - 90);
    const dpadRadius = 32.0;
    const dpadSpacing = 74.0;

    _leftBtn = _MobaCircleButton(
      imagePath: AppAssets.btnLeft,
      position: dpadCenter + Vector2(-dpadSpacing, 0),
      radius: dpadRadius,
      borderColor: const Color(0xFF78909C),
      activeColor: const Color(0xFF90CAF9),
      iconSize: 28,
      onHoldChanged: (held) {
        _leftHeld = held;
        _sendNetworkInput();
      },
      onDoubleTapChanged: (dashing) {
        _leftDashing = dashing;
        _sendNetworkInput();
      },
    );

    _rightBtn = _MobaCircleButton(
      imagePath: AppAssets.btnRight,
      position: dpadCenter + Vector2(dpadSpacing, 0),
      radius: dpadRadius,
      borderColor: const Color(0xFF78909C),
      activeColor: const Color(0xFF90CAF9),
      iconSize: 28,
      onHoldChanged: (held) {
        _rightHeld = held;
        _sendNetworkInput();
      },
      onDoubleTapChanged: (dashing) {
        _rightDashing = dashing;
        _sendNetworkInput();
      },
    );

    _jumpBtn = _MobaCircleButton(
      imagePath: AppAssets.btnUp,
      position: dpadCenter + Vector2(0, -dpadSpacing),
      radius: dpadRadius,
      borderColor: const Color(0xFF66BB6A),
      activeColor: const Color(0xFFA5D6A7),
      iconSize: 28,
      isAvailableProvider: () => !player.isDead,
      onTap: () => _pressAction(5),
    );

    _runBtn = _MobaCircleButton(
      imagePath: AppAssets.btnSprint,
      position: dpadCenter,
      radius: dpadRadius - 4,
      borderColor: const Color(0xFFFFA726),
      activeColor: const Color(0xFFFFCC80),
      iconSize: 24,
      onHoldChanged: (held) {
        _runHeld = held;
        _sendNetworkInput();
      },
    );

    // -------------------------------------------------------------
    // RIGHT MOBA COMBAT CLUSTER (Main Attack + Radial Skill Arc)
    // -------------------------------------------------------------
    // Main Normal Attack (Big central button under thumb)
    final mainAtkCenter = Vector2(sw - 90, sh - 90);
    const mainRadius = 42.0;

    _atk1Btn = _MobaCircleButton(
      imagePath: AppAssets.btnAttack,
      position: mainAtkCenter,
      radius: mainRadius,
      borderColor: const Color(0xFFFFCA28), // Golden highlight
      activeColor: const Color(0xFFFFE082),
      iconSize: 36,
      isAvailableProvider: () => !player.isDead,
      onTap: () => _pressAction(1),
    );

    // Skill 1 (ATK 2) - Positioned to the left of main attack
    _atk2Btn = _MobaCircleButton(
      imagePath: AppAssets.btnAttack,
      position: mainAtkCenter + Vector2(-90, -10),
      radius: 30.0,
      borderColor: const Color(0xFF26C6DA), // Cyan
      activeColor: const Color(0xFF80DEEA),
      iconSize: 26,
      isAvailableProvider: () => !player.isDead,
      onTap: () => _pressAction(2),
    );

    // Skill 2 (ATK 3) - Positioned diagonally top-left (Cost: 25 mana)
    _atk3Btn = _MobaCircleButton(
      imagePath: AppAssets.btnAttack,
      position: mainAtkCenter + Vector2(-70, -70),
      radius: 30.0,
      borderColor: const Color(0xFFFF7043), // Fiery Orange
      activeColor: const Color(0xFFFFAB91),
      iconSize: 26,
      manaCost: 25.0,
      currentManaProvider: () => player.mana,
      isAvailableProvider: () => !player.isDead && player.mana >= 25.0,
      onTap: () => _pressAction(3),
    );

    // Skill 3 / Ultimate (Special) - Positioned directly above main attack (Cost: 50 mana)
    _skillBtn = _MobaCircleButton(
      imagePath: AppAssets.btnSpecial,
      position: mainAtkCenter + Vector2(-10, -90),
      radius: 30.0,
      borderColor: const Color(0xFFAB47BC), // Arcane Purple
      activeColor: const Color(0xFFCE93D8),
      iconSize: 26,
      manaCost: 50.0,
      currentManaProvider: () => player.mana,
      isAvailableProvider: () => !player.isDead && player.mana >= 50.0,
      onTap: () => _pressAction(4),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _repositionButtons(size.x, size.y);
  }

  void _repositionButtons(double sw, double sh) {
    final dpadCenter = Vector2(110, sh - 90);
    const dpadSpacing = 74.0;

    _leftBtn.position = dpadCenter + Vector2(-dpadSpacing, 0);
    _rightBtn.position = dpadCenter + Vector2(dpadSpacing, 0);
    _jumpBtn.position = dpadCenter + Vector2(0, -dpadSpacing);
    _runBtn.position = dpadCenter;

    final mainAtkCenter = Vector2(sw - 90, sh - 90);
    _atk1Btn.position = mainAtkCenter;
    _atk2Btn.position = mainAtkCenter + Vector2(-90, -10);
    _atk3Btn.position = mainAtkCenter + Vector2(-70, -70);
    _skillBtn.position = mainAtkCenter + Vector2(-10, -90);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_runHeld && !_leftHeld && !_rightHeld) {
      // Holding RUN alone dashes forward in current facing direction
      if (player.facingRight) {
        player.movingRight = true;
        player.movingLeft = false;
      } else {
        player.movingLeft = true;
        player.movingRight = false;
      }
      player.sprinting = true;
    } else {
      player.movingLeft = _leftHeld;
      player.movingRight = _rightHeld;
      player.sprinting = _runHeld || _leftDashing || _rightDashing;
    }
    _networkSendTimer -= dt;
    if (_networkSendTimer <= 0) {
      _networkSendTimer = 1 / 30;
      _sendNetworkInput();
    }
  }
}
