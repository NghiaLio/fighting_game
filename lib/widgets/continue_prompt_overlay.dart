import 'dart:ui';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/screens/map_screen.dart';
import 'package:fighting_game/services/progress_service.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/pause_menu/pause_menu_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Overlay "CONTINUE?" gọn nhẹ khi kết thúc ván đấu
/// - [level]: level hiện tại (1–3), dùng để xác định hành động CONTINUE
/// - Nếu thắng: CONTINUE → chuyển sang level tiếp theo; EXIT → về home
/// - Nếu thua: CONTINUE → chơi lại cùng level; EXIT → về home
class ContinuePromptOverlay extends StatelessWidget {
  final FightingGame game;
  final int level; // giữ lại để tương thích với route hiện tại

  const ContinuePromptOverlay({
    super.key,
    required this.game,
    this.level = 1,
  });

  int get _nextRound => (game.currentRound + 1).clamp(1, 3).toInt();
  bool get _isFinalRound => game.currentRound >= 3;

  Future<void> _onContinue() async {
    AudioService.stopMatchEnd();
    if (game.isVictory) {
      if (_isFinalRound) {
        await ProgressService.onWinLevel(game.mapLevel);
        GameMatchController.to.currentLevel.value = ProgressService.currentLevel;
        if (game.mapLevel >= 7) {
          Get.offAll(() => const HomeScreen());
        } else {
          Get.offAll(() => const MapScreen());
        }
      } else {
        game.startNextRound();
      }
    } else {
      // Thua → chơi lại cùng level
      game.restartMatch();
    }
  }

  void _onExit() {
    AudioService.stopMatchEnd();
    Get.offAll(() => const MapScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isVictory = game.isVictory;

    const double boardWidth = 340;
    const double boardHeight = 260;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          builder: (context, animValue, child) {
            return Transform.scale(
              scale: animValue,
              child: Opacity(
                opacity: animValue.clamp(0.0, 1.0).toDouble(),
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Khung nền board_settings.png
                  Positioned.fill(
                    child: Image.asset(
                      AppAssets.boardSettings,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // 2. Nội dung thông báo & 2 nút nằm ngang
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(44, 26, 48, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Banner đồ họa WIN / LOSE
                          Image.asset(
                            isVictory ? AppAssets.imgWin : AppAssets.imgLose,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 3),

                          // Câu hỏi Arcade: CONTINUE?
                          Text(
                            AppStrings.continuePrompt,
                            style: GameTypography.pixel(
                              color: const Color(0xFFFFE082),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Thông điệp phụ
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                            isVictory
                                ? (_isFinalRound
                                    ? 'Map ${game.mapLevel} cleared: all 3 rounds won.'
                                    : 'Round ${game.currentRound}/3 cleared. Mana carries over at 50%.')
                                : 'Defeat in Round ${game.currentRound}/3. Retry or restart this map.',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GameTypography.pixel(
                                color: Colors.grey.shade300,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Hàng 2 nút: EXIT | CONTINUE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Nút EXIT
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: PauseMenuActionButton.secondary(
                                  label: isVictory ? 'MAP' : 'RESTART STAGE',
                                  icon: isVictory
                                      ? Icons.map_outlined
                                      : Icons.restart_alt_rounded,
                                  width: 114,
                                  height: 38,
                                  fontSize: 10.5,
                                  onTap: isVictory ? _onExit : game.restartStage,
                                ),
                              ),

                              // Nút CONTINUE / ROUND X
                              PauseMenuActionButton.resume(
                                label: game.isVictory
                                    ? (_isFinalRound ? 'CLEAR MAP' : 'ROUND $_nextRound')
                                    : 'RETRY ROUND',
                                icon: Icons.play_arrow_rounded,
                                width: 114,
                                height: 38,
                                fontSize: 10.5,
                                onTap: _onContinue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
