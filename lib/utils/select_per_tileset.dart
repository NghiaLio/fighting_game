import 'dart:ui' as ui;
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Các sprite từ select_per.png (1536 x 1024)
enum SelectPerTile {
  /// Bảng lớn chọn tướng viền vàng đính ngọc đỏ (632 x 377)
  grandRosterChamber(Rect.fromLTWH(16, 10, 632, 377)),

  /// Cột cờ anh hùng Lam (108 x 335)
  pillarBlue(Rect.fromLTWH(661, 43, 108, 335)),

  /// Cột cờ anh hùng Đỏ (106 x 332)
  pillarRed(Rect.fromLTWH(777, 44, 106, 332)),

  /// Cột cờ anh hùng Tím (106 x 332)
  pillarPurple(Rect.fromLTWH(882, 44, 106, 332)),

  /// Cột cờ anh hùng Lục (103 x 331)
  pillarGreen(Rect.fromLTWH(994, 44, 103, 331)),

  /// Cánh chim hoàng gia chữ V Valor (301 x 158)
  wingsCrest(Rect.fromLTWH(1171, 80, 301, 158)),

  /// Viên hồng ngọc đỏ (65 x 78)
  gemRuby(Rect.fromLTWH(1205, 241, 65, 78)),

  /// Viên lam ngọc xanh (65 x 80)
  gemSapphire(Rect.fromLTWH(1280, 242, 65, 80)),

  /// Viên ngọc lục bảo (66 x 82)
  gemEmerald(Rect.fromLTWH(1352, 241, 66, 82)),

  /// Khung ô vàng đại diện cho từng tướng (85 x 83)
  squareSlotFrame(Rect.fromLTWH(1110, 319, 85, 83)),

  /// Huy hiệu đầu lâu (70 x 76)
  badgeSkull(Rect.fromLTWH(1219, 338, 70, 76)),

  /// Huy hiệu vương miện (70 x 76)
  badgeCrown(Rect.fromLTWH(1291, 338, 70, 76)),

  /// Huy hiệu khiên phòng ngự (70 x 76)
  badgeShield(Rect.fromLTWH(1363, 338, 70, 76)),

  /// Huy hiệu song kiếm tấn công (72 x 76)
  badgeSwords(Rect.fromLTWH(1435, 338, 72, 76)),

  /// Thẻ đá trung đính ngọc (353 x 120)
  ornateCardPlaque(Rect.fromLTWH(16, 434, 353, 120)),

  /// Thanh tiêu đề dài có ngọc đỉnh (581 x 137)
  wideTitleBar(Rect.fromLTWH(419, 420, 581, 137)),

  /// Bảng đá lớn chữ nhật viền ngọc đỏ (481 x 194)
  heroInfoPanel(Rect.fromLTWH(1020, 420, 481, 194)),

  /// Thanh ngang ngắn (344 x 82)
  slenderBarShort(Rect.fromLTWH(35, 572, 344, 82)),

  /// Thanh ngang dài (560 x 65)
  slenderBarLong(Rect.fromLTWH(405, 578, 560, 65)),

  /// Bảng đá 3 rãnh chỉ số (463 x 205)
  statTablet3Lines(Rect.fromLTWH(24, 670, 463, 205)),

  /// Bảng đá vuông 4 rãnh chỉ số (296 x 236)
  statTablet4Lines(Rect.fromLTWH(504, 658, 296, 236)),

  /// Bảng đá có rèm nhung đỏ rủ (346 x 170)
  draperyPanel(Rect.fromLTWH(818, 685, 346, 170)),

  /// Cụm 3 cờ treo trên xà gỗ (350 x 265)
  hangingTrioBanners(Rect.fromLTWH(1171, 629, 350, 265)),

  /// Nút nhỏ (202 x 61)
  buttonSmall(Rect.fromLTWH(15, 919, 202, 61)),

  /// Nút vừa có ngọc đỉnh (392 x 80)
  buttonMedium(Rect.fromLTWH(228, 903, 392, 80)),

  /// Thanh thoi ngọc (273 x 69)
  barDiamond(Rect.fromLTWH(636, 911, 273, 69)),

  /// Nút dài nhọn viền vàng ngọc đỉnh (457 x 93)
  buttonLong(Rect.fromLTWH(934, 893, 457, 93));

  final Rect rect;
  const SelectPerTile(this.rect);
}

/// Các sprite tận dụng từ UI_tileset_2.png (666 x 375)
enum Ui2FlagTile {
  /// Cờ kiếm gothic đỏ đơn (46 x 98)
  redGothicBanner(Rect.fromLTWH(484, 265, 46, 98)),

  /// Cờ kiếm gothic lam đơn (47 x 99)
  blueGothicBanner(Rect.fromLTWH(534, 265, 47, 99)),

  /// Cờ kiếm gothic tím đơn (46 x 97)
  purpleGothicBanner(Rect.fromLTWH(585, 265, 46, 97)),

  /// Mũi tên trái (15 x 27)
  arrowLeft(Rect.fromLTWH(3, 185, 15, 27)),

  /// Mũi tên phải (18 x 26)
  arrowRight(Rect.fromLTWH(326, 181, 18, 26)),

  /// Rèm đỏ mềm (115 x 31)
  redDrapery(Rect.fromLTWH(346, 259, 115, 31));

  final Rect rect;
  const Ui2FlagTile(this.rect);
}

/// Bộ nạp ảnh cho select_per.png và UI_tileset_2.png
class SelectPerTileset {
  static const String selectPerPath = AppAssets.selectPer;
  static const String uiTileset2Path = AppAssets.uiTileset2;

  static ui.Image? _selectPerImage;
  static ui.Image? _ui2Image;

  static Future<void> preload() async {
    await Future.wait([
      _loadSelectPer(),
      _loadUi2(),
    ]);
  }

  static Future<ui.Image> _loadSelectPer() async {
    if (_selectPerImage != null) return _selectPerImage!;
    final data = await rootBundle.load(selectPerPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _selectPerImage = frame.image;
    return _selectPerImage!;
  }

  static Future<ui.Image> _loadUi2() async {
    if (_ui2Image != null) return _ui2Image!;
    final data = await rootBundle.load(uiTileset2Path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _ui2Image = frame.image;
    return _ui2Image!;
  }
}

/// Widget hiển thị sprite cắt trực tiếp từ select_per.png
class SelectPerWidget extends StatefulWidget {
  final SelectPerTile tile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;

  const SelectPerWidget({
    super.key,
    required this.tile,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.child,
  });

  @override
  State<SelectPerWidget> createState() => _SelectPerWidgetState();
}

class _SelectPerWidgetState extends State<SelectPerWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (SelectPerTileset._selectPerImage != null) {
      _image = SelectPerTileset._selectPerImage;
    } else {
      SelectPerTileset._loadSelectPer().then((img) {
        if (mounted) setState(() => _image = img);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.tile.rect.width / widget.tile.rect.height;

    Widget content = CustomPaint(
      painter: _SpriteTilePainter(
        image: _image,
        srcRect: widget.tile.rect,
        fit: widget.fit,
      ),
      child: widget.child,
    );

    if (widget.width != null && widget.height != null) {
      return SizedBox(width: widget.width, height: widget.height, child: content);
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

    return AspectRatio(aspectRatio: aspectRatio, child: content);
  }
}

/// Widget hiển thị sprite cắt từ UI_tileset_2.png (dành cho cờ và mũi tên)
class Ui2FlagWidget extends StatefulWidget {
  final Ui2FlagTile tile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;

  const Ui2FlagWidget({
    super.key,
    required this.tile,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.child,
  });

  @override
  State<Ui2FlagWidget> createState() => _Ui2FlagWidgetState();
}

class _Ui2FlagWidgetState extends State<Ui2FlagWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (SelectPerTileset._ui2Image != null) {
      _image = SelectPerTileset._ui2Image;
    } else {
      SelectPerTileset._loadUi2().then((img) {
        if (mounted) setState(() => _image = img);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.tile.rect.width / widget.tile.rect.height;

    Widget content = CustomPaint(
      painter: _SpriteTilePainter(
        image: _image,
        srcRect: widget.tile.rect,
        fit: widget.fit,
      ),
      child: widget.child,
    );

    if (widget.width != null && widget.height != null) {
      return SizedBox(width: widget.width, height: widget.height, child: content);
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

    return AspectRatio(aspectRatio: aspectRatio, child: content);
  }
}

class _SpriteTilePainter extends CustomPainter {
  final ui.Image? image;
  final Rect srcRect;
  final BoxFit fit;

  _SpriteTilePainter({
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
  bool shouldRepaint(covariant _SpriteTilePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.srcRect != srcRect;
}

/// Nút bấm tương tác cao cấp sử dụng sprite từ select_per.png
class SelectPerButton extends StatefulWidget {
  final SelectPerTile tile;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color textColor;
  final double fontSize;
  final String? soundEffect;

  const SelectPerButton({
    super.key,
    required this.tile,
    required this.label,
    required this.onTap,
    this.icon,
    this.width = 280,
    this.height = 50,
    this.textColor = const Color(0xFFFFD54F),
    this.fontSize = 15,
    this.soundEffect = 'button_2.mp3',
  });

  @override
  State<SelectPerButton> createState() => _SelectPerButtonState();
}

class _SelectPerButtonState extends State<SelectPerButton> {
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
                SelectPerWidget(
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
