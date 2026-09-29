import 'dart:ui' as ui;
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Danh mục các tile giao diện Bản đồ (Map) được cắt từ tấm `assets/images/map/tile_set_map.png`
/// Kích thước tổng thể của tấm texture: 1536 x 1024 px
enum MapTile {
  /// Thanh tiêu đề / Biển tên bản đồ chính lớn có huy hiệu đại bàng đỏ viền vàng (814 x 190)
  headerTitleBar(Rect.fromLTWH(32, 5, 814, 190)),

  /// Thanh hiển thị ngôi sao / Điểm số nhỏ góc trên (280 x 103)
  starInfoBar(Rect.fromLTWH(918, 41, 280, 103)),

  /// Khung Màn 1: Phụ bản Rừng Rậm Cổ Thụ (260 x 242)
  stage1Forest(Rect.fromLTWH(94, 176, 260, 242)),

  /// Khung Màn 2: Sa Mạc Nắng Chói & Đá Khô (275 x 240)
  stage2Desert(Rect.fromLTWH(438, 176, 275, 240)),

  /// Khung Màn 3: Núi Lửa Nham Thạch Đỏ (273 x 246)
  stage3Lava(Rect.fromLTWH(808, 178, 273, 246)),

  /// Khung Màn 4: Phế Tích Rừng Xanh Cổ Sơ (254 x 239)
  stage4Jungle(Rect.fromLTWH(1175, 178, 254, 239)),

  /// Khung Màn 5: Vùng Băng Sương Tuyết Lạnh (240 x 223)
  stage5Ice(Rect.fromLTWH(103, 441, 240, 223)),

  /// Khung Màn 6: Hang Đá Tối & Đá Đen Obsidian (260 x 226)
  stage6DarkStone(Rect.fromLTWH(445, 437, 260, 226)),

  /// Khung Màn 7: Hầm Ngục Lâu Đài & Đèn Lồng Dầu (256 x 228)
  stage7Dungeon(Rect.fromLTWH(815, 437, 256, 228)),

  /// Khung Màn 8: Vùng Biển Thẫm & Đá Lam Đáy Biển (260 x 229)
  stage8Abyssal(Rect.fromLTWH(1176, 435, 260, 229)),

  /// Khung Màn 9: Tinh Thể Tím Hư Không (247 x 232)
  stage9Void(Rect.fromLTWH(96, 686, 247, 232)),

  /// Khung Màn 10: Cung Điện Hoàng Gia Thánh Quang (272 x 236)
  stage10HolyPalace(Rect.fromLTWH(438, 679, 272, 236)),

  /// Khung Màn 11: Lôi Đài Quỷ Vương Huyết Ngục (260 x 236)
  stage11Demon(Rect.fromLTWH(814, 679, 260, 236)),

  /// Khung Màn 12: Đền Tinh Thể Xanh Bảo Ngọc (257 x 227)
  stage12Crystal(Rect.fromLTWH(1177, 691, 257, 227)),

  /// Nút bấm góc dưới: Quay lại / Trở về (129 x 87)
  buttonBack(Rect.fromLTWH(447, 928, 129, 87)),

  /// Nút bấm góc dưới: Sách tri thức / Sách thành tựu (124 x 88)
  buttonBook(Rect.fromLTWH(623, 928, 124, 88)),

  /// Nút bấm góc dưới: Cúp vô địch / Bảng xếp hạng (125 x 87)
  buttonTrophy(Rect.fromLTWH(791, 928, 125, 87)),

  /// Nút bấm góc dưới: Cài đặt hệ thống (124 x 88)
  buttonSettings(Rect.fromLTWH(957, 928, 124, 88));

  final Rect rect;
  const MapTile(this.rect);

  /// Lấy tile tương ứng với chỉ số màn (từ 1 đến 12)
  static MapTile stageTile(int stageIndex) {
    switch (stageIndex) {
      case 1:
        return MapTile.stage1Forest;
      case 2:
        return MapTile.stage2Desert;
      case 3:
        return MapTile.stage3Lava;
      case 4:
        return MapTile.stage4Jungle;
      case 5:
        return MapTile.stage5Ice;
      case 6:
        return MapTile.stage6DarkStone;
      case 7:
        return MapTile.stage7Dungeon;
      case 8:
        return MapTile.stage8Abyssal;
      case 9:
        return MapTile.stage9Void;
      case 10:
        return MapTile.stage10HolyPalace;
      case 11:
        return MapTile.stage11Demon;
      case 12:
        return MapTile.stage12Crystal;
      default:
        return MapTile.stage1Forest;
    }
  }
}

/// Trình tải và quản lý bộ nhớ đệm hình ảnh cho `assets/images/map/tile_set_map.png`
class MapTileset {
  static const String assetPath = AppAssets.tileSetMap;
  static ui.Image? _cachedImage;
  static Future<ui.Image>? _loadingFuture;

  /// Preload hình ảnh tileset map vào bộ nhớ RAM
  static Future<ui.Image> preload() => load();

  /// Tải texture map tileset
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

  /// Trả về đối tượng `ui.Image` đã được cache
  static ui.Image? get image => _cachedImage;
}

/// Widget hiển thị một mảnh sprite cắt từ `tile_set_map.png`
class MapTileWidget extends StatefulWidget {
  final MapTile tile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? child;
  final AlignmentGeometry alignment;

  const MapTileWidget({
    super.key,
    required this.tile,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.child,
    this.alignment = Alignment.center,
  });

  @override
  State<MapTileWidget> createState() => _MapTileWidgetState();
}

class _MapTileWidgetState extends State<MapTileWidget> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (MapTileset.image != null) {
      _image = MapTileset.image;
    } else {
      MapTileset.load().then((img) {
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
      painter: _MapTilePainter(
        image: _image,
        srcRect: widget.tile.rect,
        fit: widget.fit,
      ),
      child: widget.child != null
          ? Align(alignment: widget.alignment, child: widget.child)
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

class _MapTilePainter extends CustomPainter {
  final ui.Image? image;
  final Rect srcRect;
  final BoxFit fit;

  _MapTilePainter({
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
  bool shouldRepaint(covariant _MapTilePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.srcRect != srcRect ||
        oldDelegate.fit != fit;
  }
}

/// Nút bấm biểu tượng bản đồ (như Trở Về, Sách Tri Thức, Cúp Vô Địch, Cài Đặt)
class MapIconButton extends StatefulWidget {
  final MapTile tile;
  final VoidCallback onTap;
  final double width;
  final double height;
  final String? soundEffect;
  final Widget? iconOverlay;

  const MapIconButton({
    super.key,
    required this.tile,
    required this.onTap,
    this.width = 64,
    this.height = 44,
    this.soundEffect = 'button_2.mp3',
    this.iconOverlay,
  });

  @override
  State<MapIconButton> createState() => _MapIconButtonState();
}

class _MapIconButtonState extends State<MapIconButton> {
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
    final translateY = _isPressed ? 3.0 : 0.0;
    final scale = _isPressed ? 0.92 : (_isHovered ? 1.06 : 1.0);

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
                        color: const Color(0xFFFF9800).withValues(alpha: 0.6),
                        blurRadius: _isPressed ? 4 : 12,
                        spreadRadius: 1,
                        offset: Offset(0, _isPressed ? 1 : 3),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: _isPressed ? 2 : 5,
                        offset: Offset(0, _isPressed ? 1 : 3),
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                MapTileWidget(
                  tile: widget.tile,
                  width: widget.width,
                  height: widget.height,
                  child: widget.iconOverlay,
                ),
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
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

/// Component hiển thị Màn Chơi (Stage Node) trên bản đồ
class MapStageNodeWidget extends StatefulWidget {
  final int stageNumber;
  final VoidCallback onTap;
  final bool isUnlocked;
  final bool isSelected;
  final int stars; // 0..3
  final double width;
  final double height;
  final String? stageTitle;

  const MapStageNodeWidget({
    super.key,
    required this.stageNumber,
    required this.onTap,
    this.isUnlocked = true,
    this.isSelected = false,
    this.stars = 0,
    this.width = 150,
    this.height = 140,
    this.stageTitle,
  });

  @override
  State<MapStageNodeWidget> createState() => _MapStageNodeWidgetState();
}

class _MapStageNodeWidgetState extends State<MapStageNodeWidget> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails _) {
    if (!widget.isUnlocked) return;
    setState(() => _isPressed = true);
    AudioService.playButtonClick(sfx: 'button_2.mp3');
  }

  void _onTapUp(TapUpDetails _) {
    if (!widget.isUnlocked) return;
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.isUnlocked
        ? (_isPressed ? 0.93 : (_isHovered || widget.isSelected ? 1.05 : 1.0))
        : 0.95;

    return MouseRegion(
      cursor: widget.isUnlocked
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lớp viền sáng mượt khi hover/chọn
              if (widget.isSelected || _isHovered)
                Container(
                  width: widget.width + 12,
                  height: widget.height + 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isSelected
                            ? const Color(0xFFFFC107).withValues(alpha: 0.7)
                            : const Color(0xFFFF9800).withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),

              // Khung Sprite Màn Chơi
              ColorFiltered(
                colorFilter: widget.isUnlocked
                    ? const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.dst,
                      )
                    : const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0, // Red
                        0.2126, 0.7152, 0.0722, 0, 0, // Green
                        0.2126, 0.7152, 0.0722, 0, 0, // Blue
                        0,      0,      0,      0.65, 0, // Alpha
                      ]),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/Backgrounds/bg${((widget.stageNumber - 1) % 7) + 1}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Viền bao quanh
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF5D4037),
                            width: 4.0,
                          ),
                        ),
                      ),
                      // Tên màn chơi (nếu có)
                      if (widget.stageTitle != null)
                        Positioned(
                          top: widget.height * 0.15,
                          child: Text(
                            widget.stageTitle!,
                            style: GameTypography.pixel(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
                          ),
                        ),

                      // Khóa màn chơi (nếu chưa mở)
                      if (!widget.isUnlocked)
                        const Icon(
                          Icons.lock_rounded,
                          color: Color(0xFFE0E0E0),
                          size: 36,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
