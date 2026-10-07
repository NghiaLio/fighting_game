import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/data/story_service.dart';
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

  final RxInt selectedStageIndex =
      0.obs; // 0 = Pedestal xuất phát, 1..7 = Các màn chơi

  // Tọa độ vị trí bệ đá xuất phát của Tướng
  final Offset pedestalPos = const Offset(0.058, 0.745);

  static const List<MapStageData> stageDefinitions = [
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

  List<MapStageData> get stages => stageDefinitions
      .map(
        (stage) => MapStageData(
          stageNumber: stage.stageNumber,
          title: stage.title,
          tile: stage.tile,
          relativePos: stage.relativePos,
          stars: ProgressService.getStageStars(stage.stageNumber),
          isUnlocked: stage.stageNumber <= ProgressService.highestUnlockedMap,
          description: stage.description,
          bossName: stage.bossName,
        ),
      )
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
    final story = StoryService.overallStory;
    if (story == null) {
      Get.snackbar(
        'Sổ Tay',
        'Chưa có dữ liệu cốt truyện.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E100A),
        colorText: const Color(0xFFFFD54F),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          // clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: -10,
              left: 20,
              child: Image.asset(
                'assets/images/Bg2/detail_map.png',
                width: 670,
                height: 420,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    story.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3B2313),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  if (story.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        story.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF6B4E2A),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        story.content,
                        style: const TextStyle(
                          color: Color(0xFF2C1A0E),
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'ĐÓNG',
                            style: TextStyle(
                              color: Color.fromARGB(255, 214, 118, 53),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
