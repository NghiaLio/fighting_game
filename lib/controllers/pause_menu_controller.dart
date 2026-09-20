import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:get/get.dart';

/// Controller phụ trách toàn bộ nghiệp vụ (Logic & Actions) của Pause Menu
class PauseMenuController extends GetxController {
  final FightingGame game;

  PauseMenuController({required this.game});

  /// Tiếp tục trận đấu
  void resume() {
    game.overlays.remove('PauseMenu');
    game.resumeEngine();
  }

  /// Chơi lại trận đấu từ đầu
  void restart() {
    game.overlays.remove('PauseMenu');
    game.restartMatch();
    game.resumeEngine();
  }

  /// Thoát ra Menu chính
  void quitToHome() {
    game.resumeEngine();
    Get.offAll(() => const HomeScreen());
  }
}
