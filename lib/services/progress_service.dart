import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

/// Quản lý tiến trình chơi game (level) bằng Hive storage.
///
/// Stores the current campaign map and the furthest unlocked map.
class ProgressService {
  static const String _boxName = 'progress';
  static const String _keyCurrentLevel = 'current_level';
  static const String _keyHighestUnlockedMap = 'highest_unlocked_map';
  static const String _keyCoins = 'coins';
  static const String _keyUnlockedHeroes = 'unlocked_heroes';
  static const String _keyStageStars = 'stage_stars';

  static Box? _box;
  static final RxInt coinBalance = 9999.obs;

  /// Khởi tạo Hive và mở box tiến trình
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    coinBalance.value =
        _box?.get(_keyCoins, defaultValue: 9999) as int? ?? 9999;
  }

  /// Selected campaign map (1..7). Defaults to the first map.
  static int get currentLevel {
    final saved = _box?.get(_keyCurrentLevel, defaultValue: 1) as int? ?? 1;
    return saved.clamp(1, 7).toInt();
  }

  static int get highestUnlockedMap {
    final saved = _box?.get(_keyHighestUnlockedMap, defaultValue: 1) as int? ?? 1;
    return saved.clamp(1, 7).toInt();
  }

  static int get coins => coinBalance.value;

  static List<String> get unlockedHeroes {
    final values =
        _box?.get(_keyUnlockedHeroes, defaultValue: <String>[]) as List?;
    return values?.cast<String>() ?? <String>[];
  }

  static Future<bool> unlockHero({
    required String heroId,
    required int price,
  }) async {
    if (unlockedHeroes.contains(heroId) || coins < price) return false;

    final updatedCoins = coins - price;
    await _box?.put(_keyCoins, updatedCoins);
    coinBalance.value = updatedCoins;
    await _box?.put(_keyUnlockedHeroes, [...unlockedHeroes, heroId]);
    return true;
  }

  /// Lưu level mới
  static Future<void> setLevel(int level) async {
    final clamped = level.clamp(1, 7).toInt();
    await _box?.put(_keyCurrentLevel, clamped);
  }

  /// Called only after the player wins all three rounds on a map.
  static Future<void> onWinLevel(int winLevel) async {
    final nextMap = (winLevel + 1).clamp(1, 7).toInt();
    if (nextMap > highestUnlockedMap) {
      await _box?.put(_keyHighestUnlockedMap, nextMap);
    }
    await setLevel(nextMap);
  }

  static Future<void> resetCampaign() async {
    await _box?.put(_keyHighestUnlockedMap, 1);
    await setLevel(1);
  }

  static int getStageStars(int stageNumber) {
    final map = _box?.get(_keyStageStars, defaultValue: <String, int>{}) as Map?;
    return map?['stage_$stageNumber'] ?? 0;
  }

  static Future<void> saveStageStars(int stageNumber, int stars) async {
    final map = Map<String, int>.from(
      (_box?.get(_keyStageStars, defaultValue: <String, int>{}) as Map?) ?? {},
    );
    final key = 'stage_$stageNumber';
    if (stars > (map[key] ?? 0)) {
      map[key] = stars;
      await _box?.put(_keyStageStars, map);
    }
  }
}
