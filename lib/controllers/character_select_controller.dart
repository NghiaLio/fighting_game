import 'package:fighting_game/constants/hero_roster_data.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_unlock_dialog.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller quản lý màn hình chọn nhân vật (Character Select)
class CharacterSelectController extends GetxController {
  static CharacterSelectController get to =>
      Get.find<CharacterSelectController>();

  final RxInt selectedIndex = 0.obs;
  final RxSet<String> unlockedHeroIds = <String>{}.obs;

  HeroInfo get selectedHero => kHeroRoster[selectedIndex.value];

  @override
  void onInit() {
    super.onInit();
    unlockedHeroIds.addAll(ProgressService.unlockedHeroes);
    // Nạp sẵn toàn bộ hình ảnh tileset vào bộ nhớ GPU để render tức thì
    SelectPerTileset.preload();
  }

  bool isHeroUnlocked(int index) {
    return index == 0 || unlockedHeroIds.contains(kHeroRoster[index].type.name);
  }

  void selectHero(int index) {
    if (selectedIndex.value == index) return;
    if (!isHeroUnlocked(index)) {
      _showUnlockDialog(index);
      return;
    }
    // Sound được play bởi CharacterRosterPanel widget
    selectedIndex.value = index;
  }

  void _showUnlockDialog(int index) {
    final hero = kHeroRoster[index];
    Get.dialog(
      HeroUnlockDialog(
        hero: hero,
        currentLevel: ProgressService.currentLevel,
        coins: ProgressService.coins,
        onUnlock: () => unlockHero(index),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );
  }

  Future<bool> unlockHero(int index) async {
    final hero = kHeroRoster[index];
    final unlocked = await ProgressService.unlockHero(
      heroId: hero.type.name,
      price: hero.unlockPrice,
    );
    if (!unlocked) return false;

    unlockedHeroIds.add(hero.type.name);
    selectedIndex.value = index;
    return true;
  }
}
