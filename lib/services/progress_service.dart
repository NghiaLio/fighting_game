import 'package:hive_flutter/hive_flutter.dart';

/// Quản lý tiến trình chơi game (level) bằng Hive storage.
///
/// - Có 3 level: 1, 2, 3.
/// - Level hiện tại là level chưa win → lần sau vào game sẽ bắt đầu ở đây.
/// - Khi win level N mà N < 3 → lưu N+1 làm level hiện tại.
/// - Khi win level 3 → reset về 1 (hoàn thành campaign).
class ProgressService {
  static const String _boxName = 'progress';
  static const String _keyCurrentLevel = 'current_level';

  static Box? _box;

  /// Khởi tạo Hive và mở box tiến trình
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Level hiện tại (1–3). Trả về 1 nếu chưa có dữ liệu.
  static int get currentLevel {
    return _box?.get(_keyCurrentLevel, defaultValue: 1) as int? ?? 1;
  }

  /// Lưu level mới
  static Future<void> setLevel(int level) async {
    final clamped = level.clamp(1, 3);
    await _box?.put(_keyCurrentLevel, clamped);
  }

  /// Gọi khi người chơi thắng 1 level.
  /// - Nếu vừa thắng level N (N < 3) → set level hiện tại = N+1
  /// - Nếu vừa thắng level 3 → reset về 1
  static Future<void> onWinLevel(int winLevel) async {
    if (winLevel >= 3) {
      await setLevel(1); // Hoàn thành campaign → reset
    } else {
      await setLevel(winLevel + 1);
    }
  }
}
