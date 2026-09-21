import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:get/get.dart';

enum MatchState {
  playing,
  paused,
  gameOver,
}

/// Controller quản lý diễn biến trận đấu trong Game Play Screen
class GameMatchController extends GetxController {
  static GameMatchController get to => Get.find<GameMatchController>();

  final Rx<MatchState> matchState = MatchState.playing.obs;
  final RxBool isVictory = false.obs;
  final RxString endMessage = ''.obs;

  /// Trạng thái mở/đóng của màn hình Cài đặt / Tạm dừng (Pause / Setting)
  final RxBool isSettingOpen = false.obs;

  final Rx<CharacterType> playerCharacter = CharacterType.fireWizard.obs;
  final Rx<CharacterType> enemyCharacter = CharacterType.knight1.obs;

  /// Level hiện tại của campaign (1–3), đọc từ ProgressService
  final RxInt currentLevel = 1.obs;

  @override
  void onInit() {
    super.onInit();
    currentLevel.value = ProgressService.currentLevel;
  }

  void openSetting() {
    isSettingOpen.value = true;
    matchState.value = MatchState.paused;
  }

  void closeSetting() {
    isSettingOpen.value = false;
    matchState.value = MatchState.playing;
  }

  void startMatch({
    required CharacterType player,
    required CharacterType enemy,
  }) {
    playerCharacter.value = player;
    enemyCharacter.value = enemy;
    matchState.value = MatchState.playing;
    isVictory.value = false;
    isSettingOpen.value = false;
    endMessage.value = '';
  }

  void pauseGame() {
    isSettingOpen.value = true;
    matchState.value = MatchState.paused;
  }

  void resumeGame() {
    isSettingOpen.value = false;
    matchState.value = MatchState.playing;
  }

  void finishMatch({required bool victory, required String message}) {
    isVictory.value = victory;
    isSettingOpen.value = false;
    endMessage.value = message;
    matchState.value = MatchState.gameOver;
  }

  void restartMatch() {
    matchState.value = MatchState.playing;
    isVictory.value = false;
    isSettingOpen.value = false;
    endMessage.value = '';
  }

  /// Gọi khi người chơi thắng: lưu progress và advance level
  Future<void> onWinCurrentLevel() async {
    await ProgressService.onWinLevel(currentLevel.value);
    currentLevel.value = ProgressService.currentLevel;
  }

  /// Reload level từ Hive (dùng khi resume app)
  void reloadLevel() {
    currentLevel.value = ProgressService.currentLevel;
  }
}
