import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Dịch vụ quản lý âm thanh và rung phản hồi (Haptic & Audio Service).
///
/// Hỗ trợ:
/// 1. Hiệu ứng âm thanh khi bấm nút (UI Click SFX).
/// 2. Haptic feedback (Rung xúc giác nhẹ trên điện thoại khi bấm phím).
/// 3. BGM (Nhạc nền) và SFX chiêu thức trong game.
/// 4. Xử lý an toàn (safe-catch): Không gây crash game nếu chưa kịp bỏ file âm thanh vào `assets/audio/`.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Volume settings (0.0 -> 1.0)
  static double bgmVolume = 0.8;
  static double sfxVolume = 0.9;
  static bool soundEnabled = true;
  static bool hapticEnabled = true;

  /// Phát âm thanh click nút bấm kèm rung phản hồi ngón tay
  static Future<void> playButtonClick({
    String sfx = 'button.wav',
    bool triggerHaptic = true,
  }) async {
    if (triggerHaptic && hapticEnabled) {
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {
        // Bỏ qua nếu nền tảng không hỗ trợ rung
      }
    }

    if (!soundEnabled || sfxVolume <= 0) return;

    try {
      // FlameAudio tự động tìm trong thư mục assets/audio/
      await FlameAudio.play(sfx, volume: sfxVolume);
    } catch (e) {
      // Ghi log nhẹ ở chế độ Debug nếu file âm thanh chưa có
      if (kDebugMode) {
        debugPrint('[AudioService] SFX "$sfx" chưa được đặt vào assets/audio/ (Chi tiết: $e)');
      }
    }
  }

  /// Phát âm thanh khi tung chiêu thức / kỹ năng trong trận đấu
  static Future<void> playSkillSfx(String sfxName) async {
    if (!soundEnabled || sfxVolume <= 0) return;

    try {
      await FlameAudio.play(sfxName, volume: sfxVolume);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioService] Skill SFX "$sfxName" chưa có trong assets/audio/');
      }
    }
  }

  /// Phát nhạc nền BGM lặp lại
  static Future<void> playBgm(String bgmName) async {
    if (!soundEnabled || bgmVolume <= 0) return;

    try {
      await FlameAudio.bgm.play(bgmName, volume: bgmVolume);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioService] BGM "$bgmName" chưa có trong assets/audio/');
      }
    }
  }

  /// Dừng nhạc nền
  static Future<void> stopBgm() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }
}
