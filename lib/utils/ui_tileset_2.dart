import 'dart:ui' as ui;
import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Các thành phần sprite được trích xuất từ UI_tileset_2.png (666 x 375)
enum UiTile2 {
  /// Bảng chọn tướng chính 16 ô phong cách gothic (266 x 171)
  rosterGridBoard(Rect.fromLTWH(3, 2, 266, 171)),

  /// Cột cờ anh hùng màu xanh dương (49 x 158)
  heroPillarBlue(Rect.fromLTWH(271, 14, 49, 158)),

  /// Cột cờ anh hùng màu đỏ hoàng gia (53 x 163)
  heroPillarRed(Rect.fromLTWH(321, 11, 53, 163)),

  /// Cột cờ anh hùng màu tím ma thuật (53 x 162)
  heroPillarPurple(Rect.fromLTWH(377, 11, 53, 162)),

  /// Cột cờ anh hùng màu lục bảo (55 x 163)
  heroPillarGreen(Rect.fromLTWH(432, 10, 55, 163)),

  /// Bảng thông tin trên với thanh tiến trình stat (165 x 84)
  topInfoPanel(Rect.fromLTWH(497, 13, 165, 84)),

  /// Bảng thông tin dưới với ô ảnh đại diện và chỉ số (165 x 71)
  bottomInfoPanel(Rect.fromLTWH(497, 98, 165, 71)),

  /// Biểu tượng cánh chim chữ V chữ VALOR có vương miện (187 x 72)
  valorWingsCrest(Rect.fromLTWH(363, 175, 187, 72)),

  /// Thanh chọn tướng 6 ô ngang (185 x 32)
  rosterBar6(Rect.fromLTWH(36, 182, 185, 32)),

  /// Thanh chọn tướng 8 ô ngang (242 x 38)
  rosterBar8(Rect.fromLTWH(6, 222, 242, 38)),

  /// Nút kép 2 ô (92 x 32)
  doubleSlot(Rect.fromLTWH(252, 224, 92, 32)),

  /// Bảng chỉ số 4 hàng có viền đỏ nổi bật (92 x 78)
  statBox4Rows(Rect.fromLTWH(241, 263, 92, 78)),

  /// Bảng tên dài có biểu tượng kiếm thần (227 x 67)
  wideSwordPlaque(Rect.fromLTWH(6, 264, 227, 67)),

  /// Rèm lụa đỏ trang trí (115 x 31)
  redDrapery(Rect.fromLTWH(346, 259, 115, 31)),

  /// Rèm lụa lam trang trí (114 x 27)
  blueDrapery(Rect.fromLTWH(347, 290, 114, 27)),

  /// Cờ kiếm gothic đỏ rủ xuống (46 x 98)
  redGothicBanner(Rect.fromLTWH(484, 265, 46, 98)),

  /// Cờ kiếm gothic lam rủ xuống (47 x 99)
  blueGothicBanner(Rect.fromLTWH(534, 265, 47, 99)),

  /// Cờ kiếm gothic tím rủ xuống (46 x 97)
  purpleGothicBanner(Rect.fromLTWH(585, 265, 46, 97)),

  /// Nút nhọn dài viền vàng đính ngọc đỏ (209 x 37)
  longPointedButton(Rect.fromLTWH(21, 330, 209, 37)),

  /// Huy hiệu đầu lâu (29 x 30)
  badgeSkull(Rect.fromLTWH(467, 230, 29, 30)),

  /// Huy hiệu vương miện hoàng gia (30 x 30)
  badgeCrown(Rect.fromLTWH(499, 230, 30, 30)),

  /// Huy hiệu khiên phòng ngự (31 x 31)
  badgeShield(Rect.fromLTWH(535, 230, 31, 31)),

  /// Huy hiệu song kiếm tấn công (30 x 30)
  badgeSwords(Rect.fromLTWH(569, 230, 30, 30)),

  /// Ngọc đỏ hồng ngọc (23 x 30)
  rubyDiamond(Rect.fromLTWH(361, 226, 23, 30)),

  /// Ngọc lam lam ngọc (21 x 30)
  sapphireDiamond(Rect.fromLTWH(385, 226, 21, 30)),

  /// Ngọc lục bảo (23 x 30)
  emeraldDiamond(Rect.fromLTWH(407, 226, 23, 30)),

  /// Mũi tên trái (15 x 27)
  arrowLeft(Rect.fromLTWH(3, 185, 15, 27)),

  /// Mũi tên phải (18 x 26)
  arrowRight(Rect.fromLTWH(326, 181, 18, 26));

  final Rect rect;
  const UiTile2(this.rect);
}

/// Trình tải và quản lý bộ nhớ đệm hình ảnh cho UI_tileset_2.png
class UiTileset2 {
  static const String assetPath = 'assets/images/Bg_homes/UI_tileset_2.png';
  static ui.Image? _cachedImage;
  static Future<ui.Image>? _loadingFuture;

  static Future<ui.Image> load() {
    if (_cachedImage != null) {
      return Future.value(_cachedImage!);
    }
    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    _loadingFuture = _loadImage();
    return _loadingFuture!;
  }

  static Future<ui.Image> _loadImage() async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    _cachedImage = frame.image;
    return _cachedImage!;
  }
}

/// Widget hiển thị sprite cắt từ UI_tileset_2.png
class UiTile2Widget extends StatefulWidget {
  final UiTile2 tile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;

  const UiTile2Widget({
    super.key,
    required this.tile,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.child,
  });

  @override
  State<UiTile2Widget> createState() => _UiTile2WidgetState();
}

class _UiTile2WidgetState extends State<UiTile2Widget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (UiTileset2._cachedImage != null) {
      _image = UiTileset2._cachedImage;
    } else {
      UiTileset2.load().then((img) {
        if (mounted) {
          setState(() => _image = img);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.tile.rect.width / widget.tile.rect.height;

    Widget content = CustomPaint(
      painter: _UiTile2Painter(
        image: _image,
        srcRect: widget.tile.rect,
        fit: widget.fit,
      ),
      child: widget.child,
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

class _UiTile2Painter extends CustomPainter {
  final ui.Image? image;
  final Rect srcRect;
  final BoxFit fit;

  _UiTile2Painter({
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
  bool shouldRepaint(covariant _UiTile2Painter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.srcRect != srcRect ||
        oldDelegate.fit != fit;
  }
}

/// Nút bấm tương tác cao cấp sử dụng sprite từ UI_tileset_2
class UiTile2Button extends StatefulWidget {
  final UiTile2 tile;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color textColor;
  final double fontSize;
  final String? soundEffect;

  const UiTile2Button({
    super.key,
    required this.tile,
    required this.label,
    required this.onTap,
    this.icon,
    this.width = 240,
    this.height = 54,
    this.textColor = const Color(0xFFFFD54F),
    this.fontSize = 15,
    this.soundEffect = 'click.mp3',
  });

  @override
  State<UiTile2Button> createState() => _UiTile2ButtonState();
}

class _UiTile2ButtonState extends State<UiTile2Button> {
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
              alignment: Alignment.center,
              children: [
                UiTile2Widget(
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
                            style: GoogleFonts.cinzel(
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
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
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
