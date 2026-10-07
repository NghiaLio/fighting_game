import 'package:fighting_game/constants/pause_menu_assets.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/models/ai_profile.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/services/network/lan_match_session.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/widgets/continue_prompt_overlay.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:fighting_game/widgets/pause_menu_overlay.dart';
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Màn hình trận đấu (Game Play Screen)
/// - Round announcement giờ là Flame SpriteComponent bên trong HudComponent
/// - Không cần pause engine; isIntroPlaying flag block character logic
class GamePlayScreen extends StatefulWidget {
  final CharacterType playerCharacter;
  final CharacterType enemyCharacter;
  final int level;
  final LanMatchSession? networkSession;
  final bool networkHost;
  final AiProfile? customAiProfile;
  final bool isTrainingMode;

  GamePlayScreen({
    super.key,
    this.playerCharacter = CharacterType.fireWizard,
    this.enemyCharacter = CharacterType.knight1,
    this.level = 1,
    this.networkSession,
    this.networkHost = true,
    this.customAiProfile,
    this.isTrainingMode = false,
  }) : _game = FightingGame(
          playerCharacter: playerCharacter,
          enemyCharacter: enemyCharacter,
          level: level,
          networkSession: networkSession,
          networkHost: networkHost,
          customAiProfile: customAiProfile,
          isTrainingMode: isTrainingMode,
        );

  final FightingGame _game;

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  void initState() {
    super.initState();
    GameMatchController.to.startMatch(
      player: widget.playerCharacter,
      enemy: widget.enemyCharacter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ─── 1. Game canvas ───────────────────────────────────────────
          GameWidget<FightingGame>(
            game: widget._game,
            loadingBuilder: (_) => const ColoredBox(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            ),
            errorBuilder: (_, error) => ColoredBox(
              color: Colors.black,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Không thể tải trận đấu.\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            overlayBuilderMap: {
              'GameOver': (context, activeGame) =>
                  activeGame.isNetworkMatch
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xEE17120F),
                              border: Border.all(color: Colors.amber, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  activeGame.endMessage,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: () => Get.offAll(() => const HomeScreen()),
                                  child: const Text('VỀ MÀN HÌNH CHÍNH'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ContinuePromptOverlay(game: activeGame, level: widget.level),
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
                      // Sound play bởi GamePressable khi TapDown
                      GameMatchController.to.openSetting();
                      widget._game.pauseEngine();
                      widget._game.overlays.add('PauseMenu');
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

  @override
  void dispose() {
    final session = widget.networkSession;
    if (session != null) unawaited(session.leaveRoom());
    super.dispose();
  }
}
