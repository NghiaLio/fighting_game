import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/home_controller.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Màn hình chính (Home Screen)
/// - 100% [StatelessWidget] thuần túy
/// - Quản lý trạng thái, hoạt ảnh ngọn đuốc và các hộp thoại thông qua [HomeController]
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
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
          ),

          // 2. Lớp phủ Vignette tạo chiều sâu điện ảnh
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          // 3. Thanh tiêu đề trên cùng (Hồ sơ người chơi & Tiền tệ & Nút Cài đặt)
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Khung hồ sơ chiến binh
                Row(
                  children: [
                    const UiTileWidget(
                      tile: UiTile.blueBanner,
                      width: 44,
                      height: 55,
                    ),
                    const SizedBox(width: 8),
                    UiTileWidget(
                      tile: UiTile.shortButton,
                      width: 150,
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_rounded,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              AppStrings.warrior,
                              style: GameTypography.pixel(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Biểu trưng chính giữa: Rèm gấm đỏ + Logo
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        const UiTileWidget(
                          tile: UiTile.redCurtain,
                          width: 240,
                          height: 70,
                        ),
                        Positioned(
                          top: 12,
                          child: Image.asset(
                            AppAssets.gameLogo,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Ruby & Tiền vàng + Nút cài đặt nhanh
                Row(
                  children: [
                    UiTileWidget(
                      tile: UiTile.shortButton,
                      width: 130,
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const UiTileWidget(
                              tile: UiTile.rubyGem,
                              width: 20,
                              height: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.currencyAmount,
                              style: GameTypography.pixel(
                                color: const Color(0xFFFFD54F),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GamePressable(
                      onTap: controller.openSettings,
                      pressDepth: 2.0,
                      pressScale: 0.90,
                      child: const UiTileWidget(
                        tile: UiTile.rubyGem,
                        width: 36,
                        height: 38,
                        child: Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Khu vực trung tâm: Bảng tiến trình chiến dịch & Menu hành động
          Positioned(
            top: size.height * 0.22,
            bottom: size.height * 0.06,
            left: 24,
            right: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bên trái: Bảng da cuộn (Parchment Board) hiển thị màn chơi
                Flexible(
                  flex: 4,
                  child: UiTileWidget(
                    tile: UiTile.parchmentBoard,
                    height: (size.height * 0.65).clamp(240.0, 320.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 42, 36, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              AppStrings.campaignTitle,
                              style: GameTypography.pixel(
                                color: const Color(0xFF3E2723),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          const Divider(
                              color: Color(0xFF8D6E63), thickness: 1.5),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.currentStage,
                            style: GameTypography.pixel(
                              color: const Color(0xFF4E342E),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.opponent,
                            style: GameTypography.pixel(
                              color: const Color(0xFF4E342E),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.matchMode,
                            style: GameTypography.pixel(
                              color: const Color(0xFFB71C1C),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4E342E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                AppStrings.progressMaps,
                                style: GameTypography.pixel(
                                  color: const Color(0xFFFFD54F),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Bên phải: Bảng menu chính với ngọn đuốc lập lòe
                Flexible(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: controller.torchFlicker,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6F00).withValues(
                                      alpha: 0.25 *
                                          controller.torchFlicker.value),
                                  blurRadius: 30,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: UiTileWidget(
                          tile: UiTile.grandBoard,
                          height: (size.height * 0.72).clamp(280.0, 360.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Nút Bắt Đầu Chiến Đấu
                                UiTileButton(
                                  tile: UiTile.ornatePlaque,
                                  label: AppStrings.battleNow,
                                  icon: Icons.sports_kabaddi_rounded,
                                  width: 290,
                                  height: 60,
                                  fontSize: 16,
                                  textColor: const Color(0xFFFFD54F),
                                  onTap: controller.startBattle,
                                ),
                                const SizedBox(height: 10),

                                // Nút Chọn Anh Hùng
                                UiTileButton(
                                  tile: UiTile.longButton,
                                  label: AppStrings.heroesRoster,
                                  icon: Icons.shield_rounded,
                                  width: 250,
                                  height: 48,
                                  fontSize: 13,
                                  textColor: Colors.amber.shade200,
                                  onTap: controller.openCharacterSelect,
                                ),
                                const SizedBox(height: 8),

                                // Nút Cài Đặt
                                UiTileButton(
                                  tile: UiTile.longButton,
                                  label: AppStrings.settings,
                                  icon: Icons.settings_rounded,
                                  width: 250,
                                  height: 48,
                                  fontSize: 13,
                                  textColor: Colors.amber.shade200,
                                  onTap: controller.openSettings,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Cột đèn lồng góc dưới bên phải
          const Positioned(
            bottom: -20,
            right: 16,
            child: Opacity(
              opacity: 0.85,
              child: UiTileWidget(
                tile: UiTile.lanternPillar,
                width: 90,
                height: 130,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
