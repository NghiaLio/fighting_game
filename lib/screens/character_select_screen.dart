import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/hero_roster_data.dart';
import 'package:fighting_game/controllers/character_select_controller.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/screens/character_select/widgets/character_monument_stage.dart';
import 'package:fighting_game/screens/character_select/widgets/character_roster_panel.dart';
import 'package:fighting_game/screens/character_select/widgets/character_select_top_bar.dart';
import 'package:fighting_game/screens/character_select/widgets/character_specs_panel.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Màn hình chọn tướng (Character Select Screen)
/// - 100% [StatelessWidget] thuần túy
/// - Toàn bộ trạng thái & sự kiện được quản lý Reactive qua [CharacterSelectController] và [Obx]
class CharacterSelectScreen extends StatelessWidget {
  const CharacterSelectScreen({super.key});

  void _onBackToHome() {
    // Sound được play bởi widget bao ngoài (UiTileButton/GamePressable)
    Get.offAll(() => const HomeScreen());
  }

  void _onConfirmHero(CharacterSelectController controller) {
    // Sound được play bởi SelectPerButton
    final matchCtrl = GameMatchController.to;
    Get.off(() => GamePlayScreen(
      playerCharacter: controller.selectedHero.type,
      level: matchCtrl.currentLevel.value,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = CharacterSelectController.to;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final hero = controller.selectedHero;
        final selectedIndex = controller.selectedIndex.value;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Phông nền Dark Fantasy
            Image.asset(
              AppAssets.bgHome,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            // 2. Lớp phủ Vignette tối điện ảnh
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),

            // 3. Rèm lụa đỏ trang trí đỉnh màn hình từ UI_tileset_2
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Ui2FlagWidget(
                  tile: Ui2FlagTile.redDrapery,
                  height: 22,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),

            // 4. Thanh đỉnh (Top Bar)
            Positioned(
              top: 6,
              left: 16,
              right: 16,
              child: CharacterSelectTopBar(
                selectedHero: hero,
                onBack: _onBackToHome,
              ),
            ),

            // 5. Khu vực sân khấu 3 cột (Landscape Stage)
            Positioned(
              top: 50,
              bottom: 56,
              left: 12,
              right: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CỘT 1 (TRÁI): Bảng Gothic Chamber chứa danh sách 12 anh hùng
                  Expanded(
                    flex: 38,
                    child: CharacterRosterPanel(
                      roster: kHeroRoster,
                      selectedIndex: selectedIndex,
                      onSelectHero: controller.selectHero,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // CỘT 2 (GIỮA): Võ đài tôn vinh anh hùng (Cột cờ nguyên tố & Idle 60fps)
                  Expanded(
                    flex: 28,
                    child: CharacterMonumentStage(hero: hero),
                  ),

                  const SizedBox(width: 8),

                  // CỘT 3 (PHẢI): Bảng thông số, 4 chỉ số và kỹ năng / tiểu sử
                  Expanded(
                    flex: 34,
                    child: CharacterSpecsPanel(hero: hero),
                  ),
                ],
              ),
            ),

            // 6. Nút "XUẤT TRẬN" bằng sprite nhọn từ select_per: buttonLong
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Center(
                child: SelectPerButton(
                  tile: SelectPerTile.buttonLong,
                  width: 280,
                  height: 46,
                  label: AppStrings.charSelectConfirm,
                  icon: Icons.sports_kabaddi_rounded,
                  onTap: () => _onConfirmHero(controller),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
