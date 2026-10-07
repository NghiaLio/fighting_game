import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/data/story_service.dart';
import 'package:fighting_game/utils/map_tileset.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:fighting_game/widgets/home_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/controllers/map_controller.dart';
import 'package:fighting_game/models/map_stage_data.dart';

/// Màn hình Bản Đồ Chế Độ Chiến Dịch (Campaign Map Screen)
/// Tái hiện 100% giao diện bản đồ pixel fantasy theo thiết kế chuẩn.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heroPulseController;
  final MapController controller = Get.put(MapController());

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

  void _onSelectStageNode(int index, MapStageData stage) {
    controller.onSelectStageNode(index);
    _showStageDetailsModal(context, stage);
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

            final List<Offset> points = [
              Offset(
                controller.pedestalPos.dx * canvasWidth,
                controller.pedestalPos.dy * canvasHeight,
              ),
              ...controller.stages.map(
                (s) => Offset(
                  s.relativePos.dx * canvasWidth,
                  s.relativePos.dy * canvasHeight,
                ),
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
                ...List.generate(controller.stages.length, (index) {
                  final stage = controller.stages[index];
                  final nodeX = stage.relativePos.dx * canvasWidth;
                  final nodeY = stage.relativePos.dy * canvasHeight;

                  // Kích thước chuẩn khung màn chơi
                  const nodeWidth = 70.0;
                  const nodeHeight = 70.0;

                  return Positioned(
                    left: nodeX - nodeWidth / 2,
                    top: nodeY - nodeHeight / 2,
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MapStageNodeWidget(
                            stageNumber: stage.stageNumber,
                            onTap: () => _onSelectStageNode(index, stage),
                            isUnlocked: stage.isUnlocked,
                            isSelected:
                                controller.selectedStageIndex.value ==
                                index + 1,
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
                          padding: const EdgeInsets.only(
                            left: 60,
                            right: 20,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.mapTitle,
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
                                Shadow(color: Color(0xFFD84315), blurRadius: 6),
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
                          child: Text(
                            '${controller.totalEarnedStars}/${controller.totalMaxStars}',
                            style: GameTypography.pixel(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
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
                        onTap: controller.onBackToHome,
                      ),
                      const SizedBox(width: 10),
                      MapIconButton(
                        tile: MapTile.buttonBook,
                        width: 58,
                        height: 46,
                        onTap: controller.onOpenBookCodex,
                      ),
                      const SizedBox(width: 10),
                      MapIconButton(
                        tile: MapTile.buttonTrophy,
                        width: 58,
                        height: 46,
                        onTap: controller.onOpenTrophyLeaderboard,
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
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                    Shadow(color: Color(0xFFFF8F00), blurRadius: 6),
                  ]
                : const [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        );
      }),
    );
  }

  Widget _buildHeroTokenWidget(
    List<Offset> points,
    double width,
    double height,
  ) {
    return Obx(() {
      final currentPos =
          points[controller.selectedStageIndex.value.clamp(
            0,
            points.length - 1,
          )];

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
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(22, 9),
                          ),
                          color: const Color(
                            0xFFFFC107,
                          ).withValues(alpha: 0.35),
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
                          border: Border.all(
                            color: const Color(0xFFFFD54F),
                            width: 2,
                          ),
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
    });
  }

  /// Hộp thoại xem chi tiết màn chơi khi click vào 1 Node
  void _showStageDetailsModal(BuildContext context, MapStageData stage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 480,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(AppAssets.mapDialogBg),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 16, 40, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Khung Tiêu Đề Màn Chơi
                      Text(
                        '${AppStrings.mapStagePrefix} ${stage.stageNumber}: ${stage.title.toUpperCase()}',
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
                      const SizedBox(height: 16),

                      // 2 Cột: Trái (Preview Map) - Phải (Info & Achievements)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cột trái: Preview Map
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              stage.stageNumber <= 5
                                  ? 'assets/images/Bg2/bg${stage.stageNumber}.png'
                                  : 'assets/images/Backgrounds/bg${stage.stageNumber}.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Cột phải: Info & Achievements
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppStrings.mapOpponentPrefix} ${stage.bossName}',
                                  style: GameTypography.pixel(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Cốt truyện địa điểm
                                _buildStageStory(stage.stageNumber),
                                const SizedBox(height: 10),
                                // Yêu cầu 3 sao
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     _buildObjectiveRow(
                                //       AppStrings.mapObjective1,
                                //       stage.stars >= 1,
                                //     ),
                                //     _buildObjectiveRow(
                                //       AppStrings.mapObjective2,
                                //       stage.stars >= 2,
                                //     ),
                                //     _buildObjectiveRow(
                                //       AppStrings.mapObjective3,
                                //       stage.stars >= 3,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Nút Bắt Đầu Chiếm Đấu
                      if (stage.isUnlocked)
                        Center(
                          child: GestureDetector(
                            onTap: () => controller.startStage(stage),
                            child: Image.asset(
                              AppAssets.battleButton,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
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
              color: isAchieved
                  ? const Color.fromARGB(255, 114, 209, 114)
                  : const Color.fromARGB(255, 80, 78, 78),
              fontSize: 11,
              fontWeight: isAchieved ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageStory(int stageNumber) {
    final stageStory = StoryService.getStageStory(stageNumber);
    if (stageStory == null || stageStory.story.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 130),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF8B6914).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 14,
                color: Color(0xFFFFD54F),
              ),
              const SizedBox(width: 6),
              Text(
                'CỐT TRUYỆN',
                style: TextStyle(
                  color: const Color(0xFFFFD54F).withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                stageStory.story,
                style: const TextStyle(
                  color: Color(0xFFE8D5B7),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
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
