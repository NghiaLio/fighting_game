import 'package:fighting_game/constants/hero_roster_data.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:get/get.dart';

/// Controller quản lý màn hình chọn nhân vật (Character Select)
class CharacterSelectController extends GetxController {
  static CharacterSelectController get to => Get.find<CharacterSelectController>();

  final RxInt selectedIndex = 6.obs; // Mặc định: Samurai Độc Hành (index 6)

  HeroInfo get selectedHero => kHeroRoster[selectedIndex.value];

  @override
  void onInit() {
    super.onInit();
    // Nạp sẵn toàn bộ hình ảnh tileset vào bộ nhớ GPU để render tức thì
    SelectPerTileset.preload();
  }

  void selectHero(int index) {
    if (selectedIndex.value == index) return;
    // Sound được play bởi CharacterRosterPanel widget
    selectedIndex.value = index;
  }
}
