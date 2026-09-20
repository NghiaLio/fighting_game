import 'package:fighting_game/services/audio_service.dart';
import 'package:get/get.dart';

/// Controller quản lý cài đặt toàn cục trong game: Âm thanh, Rung, Cấu hình
class SettingsController extends GetxController {
  static SettingsController get to => Get.find<SettingsController>();

  final RxDouble bgmVolume = AudioService.bgmVolume.obs;
  final RxDouble sfxVolume = AudioService.sfxVolume.obs;
  final RxBool soundEnabled = AudioService.soundEnabled.obs;
  final RxBool hapticEnabled = AudioService.hapticEnabled.obs;

  void setBgmVolume(double val) {
    final clamped = val.clamp(0.0, 1.0);
    bgmVolume.value = clamped;
    AudioService.bgmVolume = clamped;
  }

  void setSfxVolume(double val) {
    final clamped = val.clamp(0.0, 1.0);
    sfxVolume.value = clamped;
    AudioService.sfxVolume = clamped;
  }

  void toggleSound() {
    AudioService.playButtonClick();
    soundEnabled.toggle();
    AudioService.soundEnabled = soundEnabled.value;
  }

  void toggleHaptic() {
    AudioService.playButtonClick();
    hapticEnabled.toggle();
    AudioService.hapticEnabled = hapticEnabled.value;
  }
}
