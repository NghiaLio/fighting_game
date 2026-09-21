import 'dart:ui';
import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/constants/pause_menu_assets.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:fighting_game/widgets/pause_menu_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Màn hình trận đấu (Game Play Screen)
/// - 100% [StatelessWidget] thuần túy
/// - Quản lý trận đấu thông qua Flame Engine [FightingGame] & [GameMatchController]
class GamePlayScreen extends StatelessWidget {
  final CharacterType playerCharacter;
  final CharacterType enemyCharacter;
  final FightingGame game;

  GamePlayScreen({
    super.key,
    this.playerCharacter = CharacterType.fireWizard,
    this.enemyCharacter = CharacterType.knight1,
  }) : game = FightingGame(
          playerCharacter: playerCharacter,
          enemyCharacter: enemyCharacter,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget<FightingGame>(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, activeGame) =>
                  GameOverOverlay(game: activeGame),
              'PauseMenu': (context, activeGame) =>
                  PauseMenuOverlay(game: activeGame),
            },
          ),

          // Nút bấm Cài đặt / Tạm dừng trên đỉnh màn hình (ẩn khi đang mở Setting)
          Obx(() {
            if (GameMatchController.to.isSettingOpen.value) {
              return const SizedBox.shrink();
            }
            return Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 80),
                  child: GamePressable(
                    onTap: () {
                      AudioService.playButtonClick();
                      GameMatchController.to.openSetting();
                      game.pauseEngine();
                      game.overlays.add('PauseMenu');
                    },
                    pressDepth: 2.5,
                    pressScale: 0.90,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        PauseMenuAssets.settingButton,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Lớp phủ kết thúc trận đấu (Game Over Overlay)
/// - 100% [StatelessWidget] thuần túy
/// - Hoạt ảnh xuất hiện mượt mà bằng [TweenAnimationBuilder]
class GameOverOverlay extends StatelessWidget {
  final FightingGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isVictory = game.isVictory;
    final primaryColor =
        isVictory ? const Color(0xFFFFD54F) : const Color(0xFFFF5252);
    final borderColor =
        isVictory ? const Color(0xFFD4AF37) : const Color(0xFFB71C1C);
    final glowColor =
        isVictory ? const Color(0xFFFF9800) : const Color(0xFFD32F2F);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4.0 * animValue.clamp(0.0, 1.0),
            sigmaY: 4.0 * animValue.clamp(0.0, 1.0),
          ),
          child: Container(
            color: Colors.black.withValues(alpha: 0.65 * animValue.clamp(0.0, 1.0)),
            alignment: Alignment.center,
            child: Opacity(
              opacity: animValue.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: animValue,
                child: Container(
                  width: 440,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141013),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.45),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.9),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Biểu tượng Cúp chiến thắng / Khiên thất bại
                      Icon(
                        isVictory
                            ? Icons.emoji_events_rounded
                            : Icons.shield_outlined,
                        color: primaryColor,
                        size: 48,
                        shadows: [Shadow(color: glowColor, blurRadius: 16)],
                      ),
                      const SizedBox(height: 8),

                      // Tiêu đề VICTORY! / DEFEAT!
                      Text(
                        isVictory
                            ? AppStrings.victory
                            : AppStrings.defeat,
                        style: GameTypography.pixel(
                          color: primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(color: glowColor, blurRadius: 14),
                            const Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Thông điệp phụ
                      Text(
                        isVictory
                            ? AppStrings.victorySubtitle
                            : AppStrings.defeatSubtitle,
                        textAlign: TextAlign.center,
                        style: GameTypography.pixel(
                          color: Colors.grey.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Hàng nút điều hướng (HOME / REPLAY)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Nút Trở Về Trang Chủ (HOME)
                          Expanded(
                            child: GamePressable(
                              onTap: () {
                                AudioService.stopMatchEnd();
                                Get.offAll(() => const HomeScreen());
                              },
                              glowColor: Colors.grey,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.home_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.gamePlayHome,
                                      style: GameTypography.pixel(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Nút Chơi Lại (REPLAY)
                          Expanded(
                            child: GamePressable(
                              onTap: () {
                                game.restartMatch();
                              },
                              glowColor: glowColor,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isVictory
                                        ? const [
                                            Color(0xFFFFD54F),
                                            Color(0xFFFF8F00),
                                          ]
                                        : const [
                                            Color(0xFFFF7043),
                                            Color(0xFFD84315),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: glowColor.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.replay_rounded,
                                      size: 20,
                                      color: isVictory
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.replay,
                                      style: GameTypography.pixel(
                                        color: isVictory
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
