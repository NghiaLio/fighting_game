import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/screens/character_select_screen.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:fighting_game/widgets/home_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller quản lý trạng thái, hoạt ảnh và điều hướng cho màn hình chính (HomeScreen)
class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
    Get.dialog(
      HomeSettingsDialog(onResetConfirmed: resetProgress),
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  /// Reset tiến trình về Round 1 rồi đóng các dialog đang mở.
  Future<void> resetProgress() async {
    await ProgressService.setLevel(1);
    GameMatchController.to.reloadLevel();
    Get.back();
    Get.back();
  }

  /// Chuyển ngay đến màn chơi trận chiến, bắt đầu từ level đã lưu
  void startBattle() {
    // Reload level từ Hive để đảm bảo dữ liệu mới nhất
    GameMatchController.to.reloadLevel();
    final level = GameMatchController.to.currentLevel.value;
    Get.off(() => GamePlayScreen(level: level));
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
