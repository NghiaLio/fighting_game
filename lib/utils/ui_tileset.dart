import 'dart:ui' as ui;
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Danh sách các sprite được cắt từ ảnh ui_tileset.png (1536 x 1024)
enum UiTile {
  /// Bảng gỗ đá lớn có 2 ngọn đuốc rực lửa 2 bên và sừng quỷ (728 x 444)
  grandBoard(Rect.fromLTWH(28, 12, 728, 444)),

  /// Bảng gỗ treo xích sắt phía trên với cờ kiếm đỏ (712 x 432)
  hangingBoard(Rect.fromLTWH(800, 0, 712, 432)),

  /// Biển tên / Thanh nút dài viền đá & gỗ đính ngọc đỏ (708 x 176)
  ornatePlaque(Rect.fromLTWH(32, 448, 708, 176)),

  /// Rèm vải đỏ / Dải băng đỏ viền vàng hoàng gia (528 x 196)
  redCurtain(Rect.fromLTWH(780, 444, 528, 196)),

  /// Cờ hiệu hiệp sĩ xanh lam có hoa văn kiếm vàng (196 x 244)
  blueBanner(Rect.fromLTWH(1324, 464, 196, 244)),

  /// Khung đá cổ lót giấy da có đầu lâu sừng quỷ (480 x 336)
  parchmentBoard(Rect.fromLTWH(16, 660, 480, 336)),

  /// Bảng gỗ ghép đinh tán viền đá đầu lâu (308 x 332)
  woodMenuBoard(Rect.fromLTWH(540, 656, 308, 332)),

  /// Cột gỗ thông báo có đèn lồng phát sáng treo cạnh (228 x 324)
  lanternPillar(Rect.fromLTWH(884, 664, 228, 324)),

  /// Nút bấm kim loại dài viền góc nhọn (368 x 68)
  longButton(Rect.fromLTWH(1156, 724, 368, 68)),

  /// Nút bấm kim loại vừa (268 x 68)
  shortButton(Rect.fromLTWH(1168, 804, 268, 68)),

  /// Đuốc lửa đang cháy (80 x 160)
  torch(Rect.fromLTWH(1424, 840, 80, 160)),

  /// Viên hồng ngọc đỏ viền vàng kim (76 x 84)
  rubyGem(Rect.fromLTWH(1188, 900, 76, 84)),

  /// Phù hiệu đầu lâu chiến binh Viking sừng cong (112 x 92)
  skullCrest(Rect.fromLTWH(1288, 896, 112, 92));

  final Rect srcRect;
  const UiTile(this.srcRect);
}

/// Singleton quản lý tải và cache ảnh ui_tileset trong RAM
class UiTileset {
  static const String assetPath = 'assets/images/Bg_homes/ui_tileset.png';
  static ui.Image? _cachedImage;

  static Future<ui.Image> load() async {
    if (_cachedImage != null) return _cachedImage!;
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _cachedImage = frame.image;
    return _cachedImage!;
  }

  static ui.Image? get image => _cachedImage;
}

/// Widget hiển thị một mảnh sprite từ ui_tileset.png
class UiTileWidget extends StatefulWidget {
  final UiTile tile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;
  final AlignmentGeometry alignment;

  const UiTileWidget({
    super.key,
    required this.tile,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.child,
    this.alignment = Alignment.center,
  });

  @override
  State<UiTileWidget> createState() => _UiTileWidgetState();
}

class _UiTileWidgetState extends State<UiTileWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (UiTileset.image != null) {
      _image = UiTileset.image;
    } else {
      UiTileset.load().then((img) {
        if (mounted) {
          setState(() {
            _image = img;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.tile.srcRect.width / widget.tile.srcRect.height;

    Widget content = CustomPaint(
      painter: _UiTilePainter(
        image: _image,
        srcRect: widget.tile.srcRect,
        fit: widget.fit,
      ),
      child: widget.child != null
          ? Align(
              alignment: widget.alignment,
              child: widget.child,
            )
          : null,
    );

    if (widget.width != null && widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: content,
      );
    } else if (widget.width != null) {
      return SizedBox(
        width: widget.width,
        height: widget.width! / aspectRatio,
        child: content,
      );
    } else if (widget.height != null) {
      return SizedBox(
        width: widget.height! * aspectRatio,
        height: widget.height,
        child: content,
      );
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: content,
    );
  }
}

class _UiTilePainter extends CustomPainter {
  final ui.Image? image;
  final Rect srcRect;
  final BoxFit fit;

  _UiTilePainter({
    required this.image,
    required this.srcRect,
    required this.fit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;

    final dstRect = Offset.zero & size;
    final paint = Paint()..filterQuality = FilterQuality.medium;

    canvas.drawImageRect(image!, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _UiTilePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.srcRect != srcRect ||
        oldDelegate.fit != fit;
  }
}

/// Nút bấm tương tác cao cấp làm từ sprite tileset
class UiTileButton extends StatefulWidget {
  final UiTile tile;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color textColor;
  final double fontSize;
  final String? soundEffect;

  const UiTileButton({
    super.key,
    required this.tile,
    required this.label,
    required this.onTap,
    this.icon,
    this.width = 240,
    this.height = 58,
    this.textColor = const Color(0xFFFFD54F),
    this.fontSize = 15,
    this.soundEffect = 'click.mp3',
  });

  @override
  State<UiTileButton> createState() => _UiTileButtonState();
}

class _UiTileButtonState extends State<UiTileButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    if (widget.soundEffect != null) {
      AudioService.playButtonClick(sfx: widget.soundEffect!);
    }
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // Độ dịch chuyển xuống theo trục Y khi ấn (Cảm giác cơ học lún nút)
    final translateY = _isPressed ? 3.5 : 0.0;
    final scale = _isPressed ? 0.94 : (_isHovered ? 1.025 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutQuad,
            transform: Matrix4.translationValues(0, translateY, 0),
            decoration: BoxDecoration(
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.55),
                        blurRadius: _isPressed ? 6 : 14,
                        spreadRadius: 1,
                        offset: Offset(0, _isPressed ? 1 : 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: _isPressed ? 2 : 6,
                        offset: Offset(0, _isPressed ? 1 : 4),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                UiTileWidget(
                  tile: widget.tile,
                  width: widget.width,
                  height: widget.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: widget.fontSize + 4,
                            color: _isHovered ? Colors.white : widget.textColor,
                            shadows: const [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GameTypography.pixel(
                              color: _isHovered ? Colors.white : widget.textColor,
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                ),
                                Shadow(
                                  color: Color(0xFFE65100),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lớp phủ sáng nhẹ khi ấn nút (Highlight flash)
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
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
