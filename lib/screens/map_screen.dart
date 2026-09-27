import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/screens/character_select_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:fighting_game/utils/map_tileset.dart';
import 'package:fighting_game/widgets/home_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dữ liệu mô tả 1 màn chơi trên Bản Đồ Chiến Dịch
class MapStageData {
  final int stageNumber;
  final String title;
  final MapTile tile;
  final Offset relativePos; // (0.0 -> 1.0) theo chiều rộng & chiều cao bản đồ
  final int stars; // 0..3
  final bool isUnlocked;
  final String description;
  final String bossName;

  const MapStageData({
    required this.stageNumber,
    required this.title,
    required this.tile,
    required this.relativePos,
    this.stars = 0,
    this.isUnlocked = true,
    this.description = '',
    this.bossName = 'Chiến Binh Hắc Ám',
  });
}

/// Màn hình Bản Đồ Chế Độ Chiến Dịch (Campaign Map Screen)
/// Tái hiện 100% giao diện bản đồ pixel fantasy theo thiết kế chuẩn.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _heroPulseController;
  int _selectedStageIndex = 0; // 0 = Pedestal xuất phát, 1..7 = Các màn chơi

  // Tọa độ vị trí bệ đá xuất phát của Tướng
  static const Offset _pedestalPos = Offset(0.058, 0.745);

  // Danh sách các màn chơi hiển thị trên Bản Đồ (Khớp vị trí với background_map.png)
  final List<MapStageData> _stages = const [
    MapStageData(
      stageNumber: 1,
      title: 'Rừng Cổ Thụ',
      tile: MapTile.stage1Forest,
      relativePos: Offset(0.155, 0.710),
      stars: 3,
      isUnlocked: true,
      description: 'Cánh rừng nguyên sinh rậm rạp, nơi trú ngụ của các chiến binh Goblin.',
      bossName: 'Thủ Lĩnh Goblin',
    ),
    MapStageData(
      stageNumber: 2,
      title: 'Hẻm Sa Mạc',
      tile: MapTile.stage2Desert,
      relativePos: Offset(0.245, 0.585),
      stars: 3,
      isUnlocked: true,
      description: 'Vùng đất cằn cỗi nhiều vách đá cuồng phong khắc nghiệt.',
      bossName: 'Bát Quái Kiếm Sĩ',
    ),
    MapStageData(
      stageNumber: 3,
      title: 'Vực Nham Thạch',
      tile: MapTile.stage3Lava,
      relativePos: Offset(0.380, 0.490),
      stars: 3,
      isUnlocked: true,
      description: 'Dòng sông dung nham sôi trào cuộn sóng dưới lòng đất sâu.',
      bossName: 'Hỏa Ma Pháp Sĩ',
    ),
    MapStageData(
      stageNumber: 4,
      title: 'Thung Lũng Chiều',
      tile: MapTile.stage4Jungle,
      relativePos: Offset(0.525, 0.625),
      stars: 3,
      isUnlocked: true,
      description: 'Thung lũng ngập tràn ánh hoàng hôn cùng tàn tích cổ xưa.',
      bossName: 'Cung Thủ Lãng Khách',
    ),
    MapStageData(
      stageNumber: 5,
      title: 'Tuyết Sơn Cổ',
      tile: MapTile.stage5Ice,
      relativePos: Offset(0.648, 0.345),
      stars: 2,
      isUnlocked: true,
      description: 'Rặng núi tuyết phủ quanh năm vĩnh cữu tàn khốc.',
      bossName: 'Hiệp Sĩ Băng Giá',
    ),
    MapStageData(
      stageNumber: 6,
      title: 'Đỉnh Giông Bão',
      tile: MapTile.stage6DarkStone,
      relativePos: Offset(0.772, 0.415),
      stars: 2,
      isUnlocked: true,
      description: 'Đỉnh núi cao chót vót luôn bị sấm sét bao phủ dồn dập.',
      bossName: 'Lôi Thần Pháp Sĩ',
    ),
    MapStageData(
      stageNumber: 7,
      title: 'Đền Phế Tích',
      tile: MapTile.stage7Dungeon,
      relativePos: Offset(0.885, 0.565),
      stars: 2,
      isUnlocked: true,
      description: 'Ngôi đền bí ẩn lưu giữ sức mạnh cổ đại tà ác.',
      bossName: 'Chiến Binh Xương Cổ',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Nạp trước bộ texture map tileset
    MapTileset.preload();

    _heroPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroPulseController.dispose();
    super.dispose();
  }

  // Tính tổng số sao đã đạt được
  int get _totalEarnedStars =>
      _stages.fold(0, (sum, stage) => sum + stage.stars);
  int get _totalMaxStars => _stages.length * 3;

  void _onSelectStageNode(int index, MapStageData stage) {
    setState(() => _selectedStageIndex = index + 1);
    AudioService.playButtonClick(sfx: 'button_2.mp3');
    _showStageDetailsModal(context, stage);
  }

  void _onBackToHome() {
    Get.offAll(() => const HomeScreen());
  }

  void _onOpenSettings() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => HomeSettingsDialog(
        onResetConfirmed: () async {
          await ProgressService.setLevel(1);
          GameMatchController.to.reloadLevel();
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onOpenBookCodex() {
    AudioService.playButtonClick(sfx: 'button_2.mp3');
    Get.snackbar(
      'SÁCH TRI THỨC',
      'Tính năng Sách Tri Thức đang được cập nhật!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E100A),
      colorText: const Color(0xFFFFD54F),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.menu_book_rounded, color: Colors.amber),
    );
  }

  void _onOpenTrophyLeaderboard() {
    AudioService.playButtonClick(sfx: 'button_2.mp3');
    Get.snackbar(
      'BẢNG XẾP HẠNG',
      'Tổng số sao chiến dịch đã đạt: $_totalEarnedStars/$_totalMaxStars ⭐',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E100A),
      colorText: const Color(0xFFFFD54F),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.emoji_events_rounded, color: Colors.amber),
    );
  }

  void _startStage(MapStageData stage) {
    Navigator.of(context).pop(); // Đóng modal
    // Cập nhật level hiện tại trong GameMatchController
    GameMatchController.to.currentLevel.value = stage.stageNumber;
    ProgressService.setLevel(stage.stageNumber);

    Get.to(() => const CharacterSelectScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasWidth = constraints.maxWidth;
            final canvasHeight = constraints.maxHeight;

            // Tính toán vị trí các node theo tọa độ tương đối
            final List<Offset> points = [
              Offset(_pedestalPos.dx * canvasWidth, _pedestalPos.dy * canvasHeight),
              ..._stages.map(
                (s) => Offset(s.relativePos.dx * canvasWidth, s.relativePos.dy * canvasHeight),
              ),
            ];

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Hình nền Bản Đồ Thế Giới (background_map.png)
                Image.asset(
                  AppAssets.backgroundMap,
                  fit: BoxFit.cover,
                  width: canvasWidth,
                  height: canvasHeight,
                ),

                // 2. Đường Dẫn Nối Các Màn Chơi (Gold Diamond Path)
                CustomPaint(
                  size: Size(canvasWidth, canvasHeight),
                  painter: _MapPathPainter(points: points),
                ),

                // 3. Render Các Khung Màn Chơi (Stage Nodes 1..7)
                ...List.generate(_stages.length, (index) {
                  final stage = _stages[index];
                  final isSelected = _selectedStageIndex == index + 1;
                  final nodeX = stage.relativePos.dx * canvasWidth;
                  final nodeY = stage.relativePos.dy * canvasHeight;

                  // Kích thước chuẩn khung màn chơi
                  const nodeWidth = 118.0;
                  const nodeHeight = 110.0;

                  return Positioned(
                    left: nodeX - nodeWidth / 2,
                    top: nodeY - nodeHeight / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MapStageNodeWidget(
                          stageNumber: stage.stageNumber,
                          onTap: () => _onSelectStageNode(index, stage),
                          isUnlocked: stage.isUnlocked,
                          isSelected: isSelected,
                          stars: stage.stars,
                          width: nodeWidth,
                          height: nodeHeight,
                        ),
                        // Thanh hiển thị 3 Ngôi Sao bên dưới khung màn chơi
                        Transform.translate(
                          offset: const Offset(0, -22),
                          child: _buildStarRatingBar(stage.stars),
                        ),
                      ],
                    ),
                  );
                }),

                // 4. Linh Vật Nhân Vật / Token Người Chơi Đang Đứng
                _buildHeroTokenWidget(points, canvasWidth, canvasHeight),

                // 5. Thanh Đỉnh Giao Diện (Top UI Bar)
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Biển tên tiêu đề bên trái
                      MapTileWidget(
                        tile: MapTile.headerTitleBar,
                        width: 260,
                        height: 58,
                        child: Container(
                          padding: const EdgeInsets.only(left: 60, right: 20),
                          alignment: Alignment.center,
                          child: Text(
                            'BẢN ĐỒ CHIẾN ĐẤU',
                            style: GameTypography.pixel(
                              color: const Color(0xFFFFD54F),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                ),
                                Shadow(
                                  color: Color(0xFFD84315),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Biển đếm sao bên phải
                      MapTileWidget(
                        tile: MapTile.starInfoBar,
                        width: 130,
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 36, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFC107),
                                size: 18,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 4),
                                ],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$_totalEarnedStars/$_totalMaxStars',
                                style: GameTypography.pixel(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  shadows: const [
                                    Shadow(color: Colors.black, blurRadius: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 6. Thanh Nút Bấm Điều Hướng Góc Dưới Bên Trái
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Row(
                    children: [
                      MapIconButton(
                        tile: MapTile.buttonBack,
                        width: 58,
                        height: 46,
                        onTap: _onBackToHome,
                      ),
                      const SizedBox(width: 10),
                      MapIconButton(
                        tile: MapTile.buttonBook,
                        width: 58,
                        height: 46,
                        onTap: _onOpenBookCodex,
                      ),
                      const SizedBox(width: 10),
                      MapIconButton(
                        tile: MapTile.buttonTrophy,
                        width: 58,
                        height: 46,
                        onTap: _onOpenTrophyLeaderboard,
                      ),
                      const SizedBox(width: 10),
                      MapIconButton(
                        tile: MapTile.buttonSettings,
                        width: 58,
                        height: 46,
                        onTap: _onOpenSettings,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Render 3 ngôi sao bên dưới khung màn chơi
  Widget _buildStarRatingBar(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isFilled = i < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Icon(
            Icons.star_rounded,
            size: 16,
            color: isFilled ? const Color(0xFFFFC107) : const Color(0xFF424242),
            shadows: isFilled
                ? const [
                    Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
                    Shadow(color: Color(0xFFFF8F00), blurRadius: 6),
                  ]
                : const [
                    Shadow(color: Colors.black, blurRadius: 2),
                  ],
          ),
        );
      }),
    );
  }

  /// Render Nhân Vật Token Đứng Trên Bệ Đá / Node Đang Chọn
  Widget _buildHeroTokenWidget(List<Offset> points, double width, double height) {
    final currentPos = points[_selectedStageIndex.clamp(0, points.length - 1)];

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      left: currentPos.dx - 32,
      top: currentPos.dy - 46,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _heroPulseController,
          builder: (context, child) {
            final scaleGlow = 1.0 + (_heroPulseController.value * 0.15);

            return SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vòng hào quang bệ đá phát sáng màu vàng kim
                  Transform.scale(
                    scale: scaleGlow,
                    child: Container(
                      width: 44,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.elliptical(22, 9)),
                        color: const Color(0xFFFFC107).withValues(alpha: 0.35),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFF9800),
                            blurRadius: 14,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Mũi tên chỉ hướng trên đầu nhân vật
                  Positioned(
                    top: 0,
                    child: Transform.translate(
                      offset: Offset(0, _heroPulseController.value * -4),
                      child: const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xFFFFD54F),
                        size: 26,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4),
                          Shadow(color: Color(0xFFFF6F00), blurRadius: 8),
                        ],
                      ),
                    ),
                  ),

                  // Sprite/Icon Nhân Vật Hiệp Sĩ Cờ Đỏ
                  Positioned(
                    bottom: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 6),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFD32F2F), Color(0xFF7B1FA2)],
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Hộp thoại xem chi tiết màn chơi khi click vào 1 Node
  void _showStageDetailsModal(BuildContext context, MapStageData stage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E140E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFC107), width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 20, spreadRadius: 4),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Khung Tiêu Đề Màn Chơi
                Text(
                  'MÀN ${stage.stageNumber}: ${stage.title.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: GameTypography.pixel(
                    color: const Color(0xFFFFD54F),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Xem trước Khung Sprite
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF5D4037)),
                  ),
                  child: Row(
                    children: [
                      MapTileWidget(
                        tile: stage.tile,
                        width: 90,
                        height: 84,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ĐỐI THỦ: ${stage.bossName}',
                              style: GameTypography.pixel(
                                color: Colors.orangeAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stage.description,
                              style: const TextStyle(
                                color: Color(0xFFD7CCC8),
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Yêu cầu 3 sao
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C1B12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildObjectiveRow('⭐ Hoàn thành chiến thắng', stage.stars >= 1),
                      _buildObjectiveRow('⭐⭐ Máu còn trên 50%', stage.stars >= 2),
                      _buildObjectiveRow('⭐⭐⭐ Thắng trong 60 giây', stage.stars >= 3),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Nút Bắt Đầu Chiếm Đấu
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD84315),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFFFD54F), width: 1.5),
                          ),
                        ),
                        onPressed: () => _startStage(stage),
                        child: Text(
                          'BẮT ĐẦU CHƠI',
                          style: GameTypography.pixel(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildObjectiveRow(String text, bool isAchieved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isAchieved ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 14,
            color: isAchieved ? const Color(0xFFFFC107) : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isAchieved ? Colors.white : Colors.grey,
              fontSize: 11,
              fontWeight: isAchieved ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter Vẽ Đường Nối Kim Cương VàngGiữa Các Màn Chơi (Golden Diamond Path)
class _MapPathPainter extends CustomPainter {
  final List<Offset> points;

  _MapPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    // 1. Cọ vẽ đường nối phát sáng màu vàng nhạt
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.4)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    // 2. Cọ vẽ đường nét đứt chính màu vàng kim
    final linePaint = Paint()
      ..color = const Color(0xFFFFC107)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // 3. Cọ vẽ các hạt kim cương nhỏ dọc theo đường nối
    final diamondPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.fill;

    final diamondBorderPaint = Paint()
      ..color = const Color(0xFFE65100)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      // Vẽ đường dẫn phát sáng
      canvas.drawLine(p1, p2, glowPaint);

      // Tính toán vị trí các điểm hạt kim cương dọc đoạn thẳng (chia làm 4 đoạn)
      const numDots = 4;
      for (int d = 1; d < numDots; d++) {
        final t = d / numDots;
        final dotX = p1.dx + (p2.dx - p1.dx) * t;
        final dotY = p1.dy + (p2.dy - p1.dy) * t;

        // Vẽ hình thoi kim cương nhỏ
        final path = Path();
        const r = 3.5;
        path.moveTo(dotX, dotY - r);
        path.lineTo(dotX + r, dotY);
        path.lineTo(dotX, dotY + r);
        path.lineTo(dotX - r, dotY);
        path.close();

        canvas.drawPath(path, diamondPaint);
        canvas.drawPath(path, diamondBorderPaint);
      }

      // Vẽ nét đứt mảnh giữa 2 điểm
      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) =>
      oldDelegate.points != points;
}
