import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';

/// Widget bọc bất kỳ phần tử nào để tạo hiệu ứng bấm vật lý 3D cao cấp (Tactile 3D Press Effect).
///
/// Các hiệu ứng bao gồm:
/// 1. Lún nút xuống theo trục Y (`translate: Offset(0, 3.5)`): Cảm giác cơ học chân thực.
/// 2. Thu nhỏ co giãn (`scale: 0.94`): Phản hồi nhịp nhàng khi chạm ngón tay.
/// 3. Nén bóng đổ (Shadow compression): Khi nhấn xuống bóng ngắn lại và nét hơn.
/// 4. Tự động phát âm thanh click (`AudioService.playButtonClick`) và rung phản hồi (Haptic).
/// 5. Bật nảy mượt mà khi nhả tay (`Curves.easeOutBack`).
class GamePressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? soundEffect;
  final double pressDepth;
  final double pressScale;
  final double hoverScale;
  final Duration animationDuration;
  final bool enableGlow;
  final Color? glowColor;

  const GamePressable({
    super.key,
    required this.child,
    required this.onTap,
    this.soundEffect = 'button_2.mp3',
    this.pressDepth = 3.5,
    this.pressScale = 0.94,
    this.hoverScale = 1.02,
    this.animationDuration = const Duration(milliseconds: 90),
    this.enableGlow = true,
    this.glowColor,
  });

  @override
  State<GamePressable> createState() => _GamePressableState();
}

class _GamePressableState extends State<GamePressable> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    if (widget.soundEffect != null) {
      AudioService.playButtonClick(sfx: widget.soundEffect!);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveScale = _isPressed
        ? widget.pressScale
        : (_isHovered ? widget.hoverScale : 1.0);

    final effectiveOffsetY = _isPressed ? widget.pressDepth : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: effectiveScale,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeOutQuad,
            transform: Matrix4.translationValues(0, effectiveOffsetY, 0),
            decoration: BoxDecoration(
              boxShadow: _isHovered && widget.enableGlow
                  ? [
                      BoxShadow(
                        color: (widget.glowColor ?? const Color(0xFFFF9800))
                            .withValues(alpha: 0.5),
                        blurRadius: 14,
                        spreadRadius: 2,
                        offset: Offset(0, _isPressed ? 1 : 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: _isPressed ? 3 : 8,
                        offset: Offset(0, _isPressed ? 1 : 4),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                widget.child,
                // Lớp phủ sáng nhẹ khi ấn xuống tạo cảm giác bề mặt nút phản xạ ánh sáng
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
