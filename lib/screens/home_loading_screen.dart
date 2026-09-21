import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/home_loading_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Màn hình tải trận (Home Loading Screen)
/// - 100% [StatelessWidget] thuần túy
/// - Quản lý tiến trình tải, hoạt ảnh và chuyển màn hình phản ứng qua [HomeLoadingController]
class HomeLoadingScreen extends StatelessWidget {
  const HomeLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeLoadingController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Phông nền Dark Medieval Scene
          Image.asset(
            AppAssets.bgHome,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black),
          ),

          // 2. Lớp phủ Vignette tạo chiều sâu
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.15,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.75),
                ],
                stops: const [0.4, 0.75, 1.0],
              ),
            ),
          ),

          // 3. Logo tựa game lướt và mờ dần vào vị trí
          Positioned(
            top: size.height * 0.06,
            left: 0,
            right: 0,
            child: Center(
              child: SlideTransition(
                position: controller.logoSlide,
                child: FadeTransition(
                  opacity: controller.logoOpacity,
                  child: ScaleTransition(
                    scale: controller.logoScale,
                    child: Hero(
                      tag: 'game_logo',
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: (size.width * 0.46).clamp(240.0, 480.0),
                          maxHeight: (size.height * 0.38).clamp(90.0, 180.0),
                        ),
                        child: Image.asset(
                          AppAssets.gameLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Thanh tiến trình tải & Dòng trạng thái
          Positioned(
            bottom: size.height * 0.08,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: (size.width * 0.62).clamp(320.0, 620.0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dòng trạng thái và phần trăm tiến độ (Reactive Obx)
                    Obx(() {
                      final progressPercent = (controller.currentProgress.value * 100)
                          .clamp(0, 100)
                          .toInt();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.statusText.value,
                            style: GameTypography.pixel(
                              color: Colors.amber.shade200,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$progressPercent%',
                            style: GameTypography.pixel(
                              color: Colors.amber.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                ),
                                Shadow(
                                  color: Color(0xFFE65100),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),

                    // Thanh nạp viền vàng hoàng kim
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E0B09),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF6F00).withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            // Dải gradient lấp đầy thanh tải (Reactive Obx)
                            Obx(() {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: controller.currentProgress.value
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFB71C1C),
                                        Color(0xFFFF6D00),
                                        Color(0xFFFFD54F),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            // Ánh sáng Shimmer quét qua thanh
                            Obx(() {
                              if (controller.currentProgress.value <= 0.05 ||
                                  controller.currentProgress.value >= 1.0) {
                                return const SizedBox.shrink();
                              }
                              return AnimatedBuilder(
                                animation: controller.shimmerController,
                                builder: (context, child) {
                                  return Positioned(
                                    left: (controller.shimmerController.value *
                                            ((size.width * 0.62)
                                                .clamp(320.0, 620.0))) -
                                        60,
                                    top: 0,
                                    bottom: 0,
                                    width: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.0),
                                            Colors.white
                                                .withValues(alpha: 0.45),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Nút bấm chạm để bắt đầu khi đã nạp 100% (Reactive Obx)
                    Obx(() {
                      return AnimatedOpacity(
                        opacity: controller.isLoaded.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: controller.startGame,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD4AF37),
                                  Color(0xFFFF8F00),
                                  Color(0xFFD4AF37),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              AppStrings.loadingTapToStart,
                              style: GameTypography.pixel(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
