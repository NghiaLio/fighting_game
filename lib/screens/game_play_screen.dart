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
/// - Round announcement giờ là Flame SpriteComponent bên trong HudComponent
/// - Không cần pause engine; isIntroPlaying flag block character logic
class GamePlayScreen extends StatelessWidget {
  final CharacterType playerCharacter;
  final CharacterType enemyCharacter;
  final int level;

  GamePlayScreen({
    super.key,
    this.playerCharacter = CharacterType.fireWizard,
    this.enemyCharacter = CharacterType.knight1,
    this.level = 1,
  }) : _game = FightingGame(
          playerCharacter: playerCharacter,
          enemyCharacter: enemyCharacter,
          level: level,
        );

  final FightingGame _game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ─── 1. Game canvas ───────────────────────────────────────────
          GameWidget<FightingGame>(
            game: _game,
            overlayBuilderMap: {
              'GameOver': (context, activeGame) =>
                  ContinuePromptOverlay(game: activeGame, level: level),
              'PauseMenu': (context, activeGame) =>
                  PauseMenuOverlay(game: activeGame),
            },
          ),

          // ─── 2. Nút Setting ───────────────────────────────────────────
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
                      _game.pauseEngine();
                      _game.overlays.add('PauseMenu');
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
