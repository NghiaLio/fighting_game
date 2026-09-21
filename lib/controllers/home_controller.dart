import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/settings_controller.dart';
import 'package:fighting_game/screens/character_select_screen.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller quản lý trạng thái, hoạt ảnh và điều hướng cho màn hình chính (HomeScreen)
class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find<HomeController>();

  late final AnimationController torchController;
  late final Animation<double> torchFlicker;

  @override
  void onInit() {
    super.onInit();

    // Tải trước texture tileset cho UI
    UiTileset.load();

    // Hiệu ứng ngọn đuốc lập lòe
    torchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    torchFlicker = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: torchController, curve: Curves.easeInOut),
    );
  }

  /// Mở hộp thoại cài đặt âm thanh (Game Settings Dialog)
  void openSettings() {
    final settingsCtrl = SettingsController.to;
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: UiTileWidget(
            tile: UiTile.hangingBoard,
            width: 480,
            height: 310,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 50, 48, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.settingsTitle,
                    style: GameTypography.pixel(
                      color: const Color(0xFFFFD54F),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nhạc nền BGM
                  Obx(() => Row(
                    children: [
                      const Icon(Icons.music_note_rounded,
                          color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.musicLabel,
                        style: GameTypography.pixel(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: settingsCtrl.bgmVolume.value,
                          activeColor: const Color(0xFFFF9800),
                          inactiveColor: Colors.black54,
                          onChanged: settingsCtrl.setBgmVolume,
                        ),
                      ),
                    ],
                  )),

                  // Âm thanh SFX
                  Obx(() => Row(
                    children: [
                      const Icon(Icons.volume_up_rounded,
                          color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.sfxLabel,
                        style: GameTypography.pixel(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: settingsCtrl.sfxVolume.value,
                          activeColor: const Color(0xFFFF9800),
                          inactiveColor: Colors.black54,
                          onChanged: settingsCtrl.setSfxVolume,
                        ),
                      ),
                    ],
                  )),

                  const Spacer(),

                  // Đóng
                  UiTileButton(
                    tile: UiTile.shortButton,
                    label: AppStrings.close,
                    width: 140,
                    height: 42,
                    fontSize: 13,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  /// Chuyển ngay đến màn chơi trận chiến (Battle Now)
  void startBattle() {
    Get.off(() => GamePlayScreen());
  }

  /// Mở màn hình chọn tướng (Character Select Screen)
  void openCharacterSelect() {
    Get.to(() => const CharacterSelectScreen());
  }

  @override
  void onClose() {
    torchController.dispose();
    super.onClose();
  }
}
