import 'dart:async';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Dịch vụ quản lý âm thanh và rung phản hồi (Haptic & Audio Service).
///
/// Hỗ trợ:
/// 1. Hiệu ứng âm thanh khi bấm nút (UI Click SFX) với độ trễ cực thấp (Low-latency AudioPool).
/// 2. Haptic feedback (Rung xúc giác nhẹ trên điện thoại khi bấm phím).
/// 3. BGM (Nhạc nền) và SFX chiêu thức trong game.
/// 4. Preload toàn bộ âm thanh vào RAM để không bị delay khi người chơi tương tác.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Volume settings (0.0 -> 1.0)
  static double bgmVolume = 0.8;
  static double sfxVolume = 0.9;
  static bool soundEnabled = true;
  static bool hapticEnabled = true;

  // Low-latency SoundPool instances
  static AudioPool? _buttonPool;

  /// Pool cho từng loại SFX chiêu thức — dùng thay FlameAudio.play() để tránh cold-start delay
  static final Map<String, AudioPool> _sfxPools = {};

  static bool _isPreloaded = false;

  /// Preload toàn bộ audio assets vào RAM & khởi tạo pool độ trễ cực thấp
  static Future<void> preloadAll() async {
    if (_isPreloaded) return;
    try {
      // 1. Nạp trước tất cả file audio vào cache bộ nhớ
      await FlameAudio.audioCache.loadAll(AppAssets.allAudio);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioService] Preload audio files error: $e');
      }
    }

    // 2. Tạo AudioPool cho button click
    try {
      _buttonPool = await FlameAudio.createPool(
        AppAssets.sfxButton,
        minPlayers: 3,
        maxPlayers: 6,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioService] Create button AudioPool error: $e');
      }
    }

    // 3. Tạo AudioPool cho từng SFX chiêu thức (pre-warm để play tức thì sau resume)
    final sfxToPool = [
      AppAssets.sfxAttack1,
      AppAssets.sfxAttack2,
      AppAssets.sfxFireWhoosh,
      AppAssets.sfxFireSpark,
      AppAssets.sfxFireballLaunch,
      AppAssets.sfxRound1,
      AppAssets.sfxRound2,
      AppAssets.sfxRound3,
      AppAssets.fight,
      AppAssets.sfxWin,
      AppAssets.sfxLose,
      AppAssets.sfxPunch,
    ];

    for (final sfx in sfxToPool) {
      try {
        _sfxPools[sfx] = await FlameAudio.createPool(
          sfx,
          minPlayers: 1,
          maxPlayers: 3,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[AudioService] Pool for "$sfx" error: $e');
        }
      }
    }

    _isPreloaded = true;
  }

  /// Phát âm thanh click nút bấm kèm rung phản hồi ngón tay (độ trễ ~0ms)
  static Future<void> playButtonClick({
    String sfx = AppAssets.sfxButton,
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

    final effectiveSfx =
        (sfx == 'click.mp3' || sfx.isEmpty) ? AppAssets.sfxButton : sfx;

    // Sử dụng AudioPool độ trễ cực thấp nếu có
    if (effectiveSfx == AppAssets.sfxButton && _buttonPool != null) {
      try {
        _buttonPool!.start(volume: sfxVolume);
        return;
      } catch (_) {
        // Fallback sang play thông thường nếu pool gặp vấn đề
      }
    }

    // Nếu pool chưa sẵn sàng, phát bằng FlameAudio thông thường và khởi tạo pool ngầm
    try {
      await FlameAudio.play(effectiveSfx, volume: sfxVolume);
      if (_buttonPool == null && effectiveSfx == AppAssets.sfxButton) {
        unawaited(preloadAll());
      }
    } catch (e) {
      if (effectiveSfx != AppAssets.sfxButton) {
        try {
          if (_buttonPool != null) {
            _buttonPool!.start(volume: sfxVolume);
          } else {
            await FlameAudio.play(AppAssets.sfxButton, volume: sfxVolume);
          }
          return;
        } catch (_) {}
      }
      if (kDebugMode) {
        debugPrint('[AudioService] SFX "$effectiveSfx" not found in assets/audio/ (Details: $e)');
      }
    }
  }

  /// Play skill SFX — dùng AudioPool để tránh cold-start delay sau resume
  static void playSkillSfx(String sfxName) {
    if (!soundEnabled || sfxVolume <= 0) return;

    // Dùng pool pre-warmed nếu có (zero latency)
    final pool = _sfxPools[sfxName];
    if (pool != null) {
      try {
        pool.start(volume: sfxVolume);
        return;
      } catch (_) {}
    }

    // Fallback: FlameAudio.play() (có delay lần đầu)
    FlameAudio.play(sfxName, volume: sfxVolume).ignore();
  }

  /// Play looping background music (BGM)
  static Future<void> playBgm(String bgmName) async {
    if (!soundEnabled || bgmVolume <= 0) return;

    try {
      await FlameAudio.bgm.play(bgmName, volume: bgmVolume);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AudioService] BGM "$bgmName" not found in assets/audio/');
      }
    }
  }

  static AudioPlayer? _matchEndPlayer;

  /// Phát âm thanh khi chiến thắng (win.mp3)
  static void playWin() {
    if (!soundEnabled || sfxVolume <= 0) return;
    try {
      stopMatchEnd();
      final pool = _sfxPools[AppAssets.sfxWin];
      if (pool != null) {
        pool.start(volume: sfxVolume);
      } else {
        FlameAudio.play(AppAssets.sfxWin, volume: sfxVolume)
            .then((p) => _matchEndPlayer = p)
            .ignore();
      }
    } catch (_) {}
  }

  /// Phát âm thanh khi thất bại (lose.mp3)
  static void playLose() {
    if (!soundEnabled || sfxVolume <= 0) return;
    try {
      stopMatchEnd();
      final pool = _sfxPools[AppAssets.sfxLose];
      if (pool != null) {
        pool.start(volume: sfxVolume);
      } else {
        FlameAudio.play(AppAssets.sfxLose, volume: sfxVolume)
            .then((p) => _matchEndPlayer = p)
            .ignore();
      }
    } catch (_) {}
  }

  /// Phát âm thanh kết thúc trận đấu (win.mp3 hoặc lose.mp3)
  static void playMatchEnd({required bool isVictory}) {
    if (isVictory) {
      playWin();
    } else {
      playLose();
    }
  }

  /// Dừng âm thanh kết thúc trận đấu nếu đang phát
  static Future<void> stopMatchEnd() async {
    try {
      await _matchEndPlayer?.stop();
      _matchEndPlayer = null;
    } catch (_) {}
  }

  /// Dừng nhạc nền
  static Future<void> stopBgm() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }
}
