import 'package:fighting_game/constants/pause_menu_assets.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/continue_prompt_overlay.dart';
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
                  ContinuePromptOverlay(game: activeGame),
              'PauseMenu': (context, activeGame) =>
                  PauseMenuOverlay(game: activeGame),
            },
          ),

          // Nút bấm Cài đặt / Tạm dừng trên đỉnh màn hình (ẩn khi đang mở Setting hoặc khi hiện ContinuePrompt)
          Obx(() {
            final matchCtrl = GameMatchController.to;
            if (matchCtrl.isSettingOpen.value ||
                matchCtrl.matchState.value == MatchState.gameOver) {
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
