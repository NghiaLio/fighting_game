import 'dart:ui' as ui;
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget render sprite Idle động của nhân vật được chọn bằng Canvas CustomPainter
class HeroIdlePreview extends StatefulWidget {
  final CharacterType characterType;
  final int frameCount;
  final double size;

  const HeroIdlePreview({
    super.key,
    required this.characterType,
    required this.frameCount,
    required this.size,
  });

  @override
  State<HeroIdlePreview> createState() => _HeroIdlePreviewState();
}

class _HeroIdlePreviewState extends State<HeroIdlePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 140 * widget.frameCount),
    )..repeat();

    _loadSprite();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSprite() async {
    try {
      final path =
          AppAssets.characterIdleFlutterPath(widget.characterType.spritePath);
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
      return SizedBox(
        width: widget.size,
        height: widget.size,
      );
    }

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final currentFrame =
            (_animController.value * widget.frameCount).floor() %
                widget.frameCount;

        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpriteFramePainter(
            image: _image!,
            frameIndex: currentFrame,
          ),
        );
      },
    );
  }
}

class _SpriteFramePainter extends CustomPainter {
  final ui.Image image;
  final int frameIndex;

  _SpriteFramePainter({required this.image, required this.frameIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final srcRect = Rect.fromLTWH(frameIndex * 128.0, 0, 128, 128);
    final dstRect = Offset.zero & size;
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _SpriteFramePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.frameIndex != frameIndex;
}
