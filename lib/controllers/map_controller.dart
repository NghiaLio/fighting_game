import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/models/map_stage_data.dart';
import 'package:fighting_game/screens/character_select_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:fighting_game/utils/map_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapController extends GetxController {
  static MapController get to => Get.find<MapController>();

  final RxInt selectedStageIndex = 0.obs; // 0 = Pedestal xuất phát, 1..7 = Các màn chơi

  // Tọa độ vị trí bệ đá xuất phát của Tướng
  final Offset pedestalPos = const Offset(0.058, 0.745);

  // Danh sách các màn chơi hiển thị trên Bản Đồ
  static const List<MapStageData> _stageDefinitions = [
    MapStageData(
      stageNumber: 1,
      title: AppStrings.mapStage1Title,
      tile: MapTile.stage1Forest,
      relativePos: Offset(0.155, 0.710),
      stars: 3,
      isUnlocked: true,
      description: AppStrings.mapStage1Desc,
      bossName: AppStrings.mapStage1Boss,
    ),
    MapStageData(
      stageNumber: 2,
      title: AppStrings.mapStage2Title,
      tile: MapTile.stage2Desert,
      relativePos: Offset(0.245, 0.585),
      stars: 3,
      isUnlocked: true,
      description: AppStrings.mapStage2Desc,
      bossName: AppStrings.mapStage2Boss,
    ),
    MapStageData(
      stageNumber: 3,
      title: AppStrings.mapStage3Title,
      tile: MapTile.stage3Lava,
      relativePos: Offset(0.380, 0.490),
      stars: 3,
      isUnlocked: true,
      description: AppStrings.mapStage3Desc,
      bossName: AppStrings.mapStage3Boss,
    ),
    MapStageData(
      stageNumber: 4,
      title: AppStrings.mapStage4Title,
      tile: MapTile.stage4Jungle,
      relativePos: Offset(0.525, 0.625),
      stars: 3,
      isUnlocked: true,
      description: AppStrings.mapStage4Desc,
      bossName: AppStrings.mapStage4Boss,
    ),
    MapStageData(
      stageNumber: 5,
      title: AppStrings.mapStage5Title,
      tile: MapTile.stage5Ice,
      relativePos: Offset(0.648, 0.345),
      stars: 2,
      isUnlocked: true,
      description: AppStrings.mapStage5Desc,
      bossName: AppStrings.mapStage5Boss,
    ),
    MapStageData(
      stageNumber: 6,
      title: AppStrings.mapStage6Title,
      tile: MapTile.stage6DarkStone,
      relativePos: Offset(0.772, 0.415),
      stars: 2,
      isUnlocked: true,
      description: AppStrings.mapStage6Desc,
      bossName: AppStrings.mapStage6Boss,
    ),
    MapStageData(
      stageNumber: 7,
      title: AppStrings.mapStage7Title,
      tile: MapTile.stage7Dungeon,
      relativePos: Offset(0.885, 0.565),
      stars: 2,
      isUnlocked: true,
      description: AppStrings.mapStage7Desc,
      bossName: AppStrings.mapStage7Boss,
    ),
  ];

  List<MapStageData> get stages => _stageDefinitions
      .map((stage) => MapStageData(
            stageNumber: stage.stageNumber,
            title: stage.title,
            tile: stage.tile,
            relativePos: stage.relativePos,
            stars: ProgressService.getStageStars(stage.stageNumber),
            isUnlocked: stage.stageNumber <= ProgressService.highestUnlockedMap,
            description: stage.description,
            bossName: stage.bossName,
          ))
      .toList(growable: false);

  int get totalEarnedStars => stages.fold(0, (sum, stage) => sum + stage.stars);
  int get totalMaxStars => stages.length * 3;

  void onSelectStageNode(int index) {
    selectedStageIndex.value = index + 1;
    AudioService.playButtonClick(sfx: 'button_2.mp3');
  }

  void onBackToHome() {
    Get.offAll(() => const HomeScreen());
  }

  void onOpenBookCodex() {
    AudioService.playButtonClick(sfx: 'button_2.mp3');
    Get.snackbar(
      AppStrings.mapBookTitle,
      AppStrings.mapBookContent,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E100A),
      colorText: const Color(0xFFFFD54F),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.menu_book_rounded, color: Colors.amber),
    );
  }

  void onOpenTrophyLeaderboard() {
    AudioService.playButtonClick(sfx: 'button_2.mp3');
    Get.snackbar(
      AppStrings.mapLeaderboardTitle,
      '${AppStrings.mapLeaderboardContent}$totalEarnedStars/$totalMaxStars ⭐',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E100A),
      colorText: const Color(0xFFFFD54F),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.emoji_events_rounded, color: Colors.amber),
    );
  }

  void startStage(MapStageData stage) {
    Get.back(); // Đóng modal (nếu có modal đang mở)
    if (stage.stageNumber > ProgressService.highestUnlockedMap) return;
    
    // Cập nhật level hiện tại trong GameMatchController
    GameMatchController.to.currentLevel.value = stage.stageNumber;
    ProgressService.setLevel(stage.stageNumber);

    Get.to(() => const CharacterSelectScreen());
  }

  Future<void> onResetProgress() async {
    await ProgressService.resetCampaign();
    GameMatchController.to.reloadLevel();
  }
}
