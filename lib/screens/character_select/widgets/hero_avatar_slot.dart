import 'dart:ui' as ui;
import 'package:fighting_game/enums/character_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ô avatar chân dung pixel art frame đầu tiên trong ô chọn tướng
class HeroAvatarSlot extends StatefulWidget {
  final CharacterType characterType;
  final Color primaryColor;
  final bool isSelected;

  const HeroAvatarSlot({
    super.key,
    required this.characterType,
    required this.primaryColor,
    required this.isSelected,
  });

  @override
  State<HeroAvatarSlot> createState() => _HeroAvatarSlotState();
}

class _HeroAvatarSlotState extends State<HeroAvatarSlot> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadSprite();
  }

  Future<void> _loadSprite() async {
    try {
      final path = 'assets/images/${widget.characterType.spritePath}/Idle.png';
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() => _image = frame.image);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return Container(
        color: const Color(0xFF1B1622),
        child: const Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.amber),
          ),
        ),
      );
    }

    return CustomPaint(
      painter: _FirstFramePainter(image: _image!),
    );
  }
}

class _FirstFramePainter extends CustomPainter {
  final ui.Image image;
  _FirstFramePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    const srcRect = Rect.fromLTWH(0, 0, 128, 128);
    final dstRect = Offset.zero & size;
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _FirstFramePainter oldDelegate) =>
      oldDelegate.image != image;
}
