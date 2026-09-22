import 'dart:ui';
import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
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
  final int level; // giữ lại để tương thích, nhưng logic dùng game.currentLevel

  const ContinuePromptOverlay({
    super.key,
    required this.game,
    this.level = 1,
  });

  /// Round hiện tại — luôn đọc từ game để phản ánh đúng sau startNewLevel()
  int get _currentLevel => game.currentLevel;

  /// Round tiếp theo (không vượt 3)
  int get _nextLevel => (_currentLevel + 1).clamp(1, 3);

  /// true: đang ở round cuối (round 3)
  bool get _isFinalRound => _currentLevel >= 3;

  void _onContinue() {
    AudioService.stopMatchEnd();
    if (game.isVictory) {
      // Lưu tiến trình Hive (fire-and-forget)
      GameMatchController.to.onWinCurrentLevel();
      if (_isFinalRound) {
        // Xong round 3 → về HomeScreen (campaign hoàn thành)
        Get.offAll(() => const HomeScreen());
      } else {
        // Reset game tại chỗ với round mới
        game.startNewLevel(_nextLevel);
      }
    } else {
      // Thua → chơi lại cùng level
      game.restartMatch();
    }
  }

  void _onExit() {
    AudioService.stopMatchEnd();
    Get.offAll(() => const HomeScreen());
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
              child: Opacity(opacity: animValue.clamp(0.0, 1.0), child: child),
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
                                  ? AppStrings.victorySubtitle
                                  : AppStrings.defeatSubtitle,
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
                                  label: AppStrings.exitAction,
                                  icon: Icons.exit_to_app_rounded,
                                  width: 114,
                                  height: 38,
                                  fontSize: 10.5,
                                  onTap: _onExit,
                                ),
                              ),

                              // Nút CONTINUE / ROUND X
                              PauseMenuActionButton.resume(
                                label: game.isVictory
                                    ? (_isFinalRound ? 'CONTINUE' : 'ROUND $_nextLevel')
                                    : 'RETRY',
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
