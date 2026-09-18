import 'package:fighting_game/game/components/character_component.dart';
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
  final String label;
  final double iconSize;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHoldChanged;
  final ValueChanged<bool>? onDoubleTapChanged;

  bool _isPressed = false;
  DateTime _lastTapTime = DateTime.fromMillisecondsSinceEpoch(0);
  Sprite? _sprite;

  _MobaCircleButton({
    required this.imagePath,
    required Vector2 position,
    required this.radius,
    required this.borderColor,
    required this.activeColor,
    required this.label,
    required this.iconSize,
    this.onTap,
    this.onHoldChanged,
    this.onDoubleTapChanged,
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
  void onTapDown(TapDownEvent event) {
    _isPressed = true;
    scale = Vector2.all(0.90);

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

    final center = Offset(radius, radius);

    // 1. Dark frosted circular background
    final bgPaint = Paint()
      ..color = _isPressed
          ? activeColor.withValues(alpha: 0.45)
          : const Color(0xD8101424);
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Outer decorative ring
    final outerRingPaint = Paint()
      ..color = _isPressed ? activeColor : borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _isPressed ? 2.6 : 2.0;
    canvas.drawCircle(center, radius - 1, outerRingPaint);

    // 3. Inner subtle accent circle
    final innerRingPaint = Paint()
      ..color = (_isPressed ? activeColor : borderColor).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius - 4.5, innerRingPaint);

    // 4. Sharp, un-stretched centered icon
    if (_sprite != null) {
      final iconOffset = Offset(radius - iconSize / 2, radius - iconSize / 2);
      _sprite!.render(
        canvas,
        position: Vector2(iconOffset.dx, iconOffset.dy),
        size: Vector2.all(iconSize),
      );
    }

    // 5. Small MOBA badge label
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: _isPressed ? Colors.white : Colors.white70,
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(radius - tp.width / 2, radius * 2 - 12));
  }
}

/// MOBA-style controls: Arc layout for attacks & clean circular D-pad.
class GameControls extends Component with HasGameReference {
  final CharacterComponent player;

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

  GameControls({required this.player});

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
    final dpadCenter = Vector2(82, sh - 68);
    const dpadRadius = 23.0;
    const dpadSpacing = 48.0;

    _leftBtn = _MobaCircleButton(
      imagePath: 'Buttons/left.png',
      position: dpadCenter + Vector2(-dpadSpacing, 0),
      radius: dpadRadius,
      borderColor: const Color(0xFF78909C),
      activeColor: const Color(0xFF90CAF9),
      label: 'LEFT',
      iconSize: 22,
      onHoldChanged: (held) => _leftHeld = held,
      onDoubleTapChanged: (dashing) => _leftDashing = dashing,
    );

    _rightBtn = _MobaCircleButton(
      imagePath: 'Buttons/right.png',
      position: dpadCenter + Vector2(dpadSpacing, 0),
      radius: dpadRadius,
      borderColor: const Color(0xFF78909C),
      activeColor: const Color(0xFF90CAF9),
      label: 'RIGHT',
      iconSize: 22,
      onHoldChanged: (held) => _rightHeld = held,
      onDoubleTapChanged: (dashing) => _rightDashing = dashing,
    );

    _jumpBtn = _MobaCircleButton(
      imagePath: 'Buttons/up.png',
      position: dpadCenter + Vector2(0, -dpadSpacing),
      radius: dpadRadius,
      borderColor: const Color(0xFF66BB6A),
      activeColor: const Color(0xFFA5D6A7),
      label: 'JUMP',
      iconSize: 22,
      onTap: () => player.wantsJump = true,
    );

    _runBtn = _MobaCircleButton(
      imagePath: 'Buttons/sprint.png',
      position: dpadCenter,
      radius: dpadRadius - 2,
      borderColor: const Color(0xFFFFA726),
      activeColor: const Color(0xFFFFCC80),
      label: 'RUN',
      iconSize: 20,
      onHoldChanged: (held) => _runHeld = held,
    );

    // -------------------------------------------------------------
    // RIGHT MOBA COMBAT CLUSTER (Main Attack + Radial Skill Arc)
    // -------------------------------------------------------------
    // Main Normal Attack (Big central button under thumb)
    final mainAtkCenter = Vector2(sw - 58, sh - 58);
    const mainRadius = 32.0;

    _atk1Btn = _MobaCircleButton(
      imagePath: 'Buttons/attack.png',
      position: mainAtkCenter,
      radius: mainRadius,
      borderColor: const Color(0xFFFFCA28), // Golden highlight
      activeColor: const Color(0xFFFFE082),
      label: 'ATK 1',
      iconSize: 28,
      onTap: () => player.wantsAttack1 = true,
    );

    // Skill 1 (ATK 2) - Positioned to the left of main attack
    _atk2Btn = _MobaCircleButton(
      imagePath: 'Buttons/attack.png',
      position: mainAtkCenter + Vector2(-68, -6),
      radius: 23.0,
      borderColor: const Color(0xFF26C6DA), // Cyan
      activeColor: const Color(0xFF80DEEA),
      label: 'ATK 2',
      iconSize: 20,
      onTap: () => player.wantsAttack2 = true,
    );

    // Skill 2 (ATK 3) - Positioned diagonally top-left
    _atk3Btn = _MobaCircleButton(
      imagePath: 'Buttons/attack.png',
      position: mainAtkCenter + Vector2(-54, -54),
      radius: 23.0,
      borderColor: const Color(0xFFFF7043), // Fiery Orange
      activeColor: const Color(0xFFFFAB91),
      label: 'ATK 3',
      iconSize: 20,
      onTap: () => player.wantsAttack3 = true,
    );

    // Skill 3 / Ultimate (Special) - Positioned directly above main attack
    _skillBtn = _MobaCircleButton(
      imagePath: 'Buttons/special.png',
      position: mainAtkCenter + Vector2(-6, -68),
      radius: 24.0,
      borderColor: const Color(0xFFAB47BC), // Arcane Purple
      activeColor: const Color(0xFFCE93D8),
      label: 'ULT',
      iconSize: 22,
      onTap: () => player.wantsSpecial = true,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) return;
    _repositionButtons(size.x, size.y);
  }

  void _repositionButtons(double sw, double sh) {
    final dpadCenter = Vector2(82, sh - 68);
    const dpadSpacing = 48.0;

    _leftBtn.position = dpadCenter + Vector2(-dpadSpacing, 0);
    _rightBtn.position = dpadCenter + Vector2(dpadSpacing, 0);
    _jumpBtn.position = dpadCenter + Vector2(0, -dpadSpacing);
    _runBtn.position = dpadCenter;

    final mainAtkCenter = Vector2(sw - 58, sh - 58);
    _atk1Btn.position = mainAtkCenter;
    _atk2Btn.position = mainAtkCenter + Vector2(-68, -6);
    _atk3Btn.position = mainAtkCenter + Vector2(-54, -54);
    _skillBtn.position = mainAtkCenter + Vector2(-6, -68);
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
  }
}
