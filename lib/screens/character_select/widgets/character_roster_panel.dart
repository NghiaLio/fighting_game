import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_slot_item.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// Cột trái: Bảng lớn Gothic Chamber chứa danh sách 12 anh hùng
/// Thiết kế lưới 4 ô mỗi hàng (3 hàng x 4 cột), ô to rõ nét, tiêu đề đưa xuống dưới đáy bảng
class CharacterRosterPanel extends StatelessWidget {
  final List<HeroInfo> roster;
  final int selectedIndex;
  final ValueChanged<int> onSelectHero;
  final bool Function(int index) isHeroUnlocked;

  const CharacterRosterPanel({
    super.key,
    required this.roster,
    required this.selectedIndex,
    required this.onSelectHero,
    required this.isHeroUnlocked,
  });

  HeroInfo get _selectedHero => roster[selectedIndex];

  @override
  Widget build(BuildContext context) {
    return SelectPerWidget(
      tile: SelectPerTile.grandRosterChamber,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 26, 16, 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Text(
                AppStrings.charSelectTitle,
                style: GameTypography.pixel(
                  color: const Color(0xFFFFD54F),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
            // Vùng danh sách co giãn theo khung và có thể cuộn khi số tướng tăng.
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: (roster.length + 2) ~/ 3,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, row) {
                  final startIndex = row * 3;
                  final endIndex = (startIndex + 3).clamp(0, roster.length);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(endIndex - startIndex, (column) {
                      final index = startIndex + column;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        isLocked: !isHeroUnlocked(index),
                        onTap: () => onSelectHero(index),
                        size: 60,
                      );
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Dòng tiêu đề đưa xuống dưới đáy bảng để vừa vặn trong lòng khung đá
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.charSelectRosterTitle,
                    style: GameTypography.pixel(
                      color: const Color(0xFFFFD54F),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${_selectedHero.name} [${_selectedHero.shortRole}] •',
                    style: GameTypography.pixel(
                      color: _selectedHero.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 4),
                      ],
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
}
