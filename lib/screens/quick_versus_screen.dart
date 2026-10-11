import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/models/ai_profile.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AiDifficulty { easy, normal, hard }

class QuickVersusScreen extends StatefulWidget {
  const QuickVersusScreen({super.key});

  @override
  State<QuickVersusScreen> createState() => _QuickVersusScreenState();
}

class _QuickVersusScreenState extends State<QuickVersusScreen> {
  CharacterType _playerChar = CharacterType.fireWizard;
  CharacterType _enemyChar = CharacterType.knight1;
  AiDifficulty _difficulty = AiDifficulty.normal;

  static const Map<AiDifficulty, String> _labels = {
    AiDifficulty.easy: 'DỄ',
    AiDifficulty.normal: 'VỪA',
    AiDifficulty.hard: 'KHÓ',
  };

  static const Map<AiDifficulty, Color> _colors = {
    AiDifficulty.easy: Colors.green,
    AiDifficulty.normal: Colors.orange,
    AiDifficulty.hard: Colors.red,
  };

  AiProfile _getAiProfile() {
    return switch (_difficulty) {
      AiDifficulty.easy => AiProfile(
          minThinkDelay: 1.0, maxThinkDelay: 1.5,
          blockChance: 0.0, comboChance: 0.05,
          jumpChance: 0.05, specialChance: 0.10,
          runThreshold: 260,
          hpMultiplier: 0.85, damageMultiplier: 0.75,
        ),
      AiDifficulty.normal => AiProfile(
          minThinkDelay: 0.60, maxThinkDelay: 0.95,
          blockChance: 0.18, comboChance: 0.25,
          jumpChance: 0.15, specialChance: 0.25,
          runThreshold: 210,
          hpMultiplier: 0.95, damageMultiplier: 0.90,
        ),
      AiDifficulty.hard => AiProfile(
          minThinkDelay: 0.32, maxThinkDelay: 0.55,
          blockChance: 0.42, comboChance: 0.50,
          jumpChance: 0.30, specialChance: 0.50,
          runThreshold: 170,
          hpMultiplier: 1.08, damageMultiplier: 1.08,
        ),
    };
  }

  String _charName(CharacterType type) => type.displayName;

  void _startFight() {
    final profile = _getAiProfile();
    Get.off(
      () => GamePlayScreen(
        playerCharacter: _playerChar,
        enemyCharacter: _enemyChar,
        level: 1,
        customAiProfile: profile,
      ),
    );
  }

  Widget _buildCharRow({
    required String title,
    required CharacterType selected,
    required ValueChanged<CharacterType> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GameTypography.pixel(
            color: const Color(0xFFFFD54F),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: CharacterType.values.map((type) {
            final isSelected = type == selected;
            return GestureDetector(
              onTap: () => onSelected(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD54F).withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFD54F)
                        : Colors.grey.withValues(alpha: 0.4),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  _charName(type),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    SelectPerTileset.preload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgHome, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.offAll(() => const HomeScreen()),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'CHẾ ĐỘ LUYỆN TẬP',
                        style: GameTypography.pixel(
                          color: const Color(0xFFFFD54F),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCharRow(
                            title: 'NHÂN VẬT CỦA BẠN',
                            selected: _playerChar,
                            onSelected: (c) => setState(() => _playerChar = c),
                          ),
                          const SizedBox(height: 20),
                          _buildCharRow(
                            title: 'ĐỐI THỦ AI',
                            selected: _enemyChar,
                            onSelected: (c) => setState(() => _enemyChar = c),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'ĐỘ KHÓ CỦA AI',
                            style: GameTypography.pixel(
                              color: const Color(0xFFFFD54F),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: AiDifficulty.values.map((diff) {
                              final isSelected = diff == _difficulty;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () => setState(() => _difficulty = diff),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _colors[diff]!.withValues(alpha: 0.3)
                                          : Colors.black.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? _colors[diff]!
                                            : Colors.grey.withValues(alpha: 0.4),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      _labels[diff]!,
                                      style: TextStyle(
                                        color: isSelected
                                            ? _colors[diff]!
                                            : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: GestureDetector(
                              onTap: _startFight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD84315),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFFFD54F),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.sports_kabaddi,
                                        color: Colors.white, size: 22),
                                    const SizedBox(width: 10),
                                    Text(
                                      'BẮT ĐẦU LUYỆN TẬP',
                                      style: GameTypography.pixel(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
