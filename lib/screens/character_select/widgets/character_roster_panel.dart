import 'package:fighting_game/constants/character_select_strings.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_slot_item.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cột trái: Bảng lớn Gothic Chamber chứa danh sách 12 anh hùng
/// Thiết kế lưới 4 ô mỗi hàng (3 hàng x 4 cột), ô to rõ nét, tiêu đề đưa xuống dưới đáy bảng
class CharacterRosterPanel extends StatelessWidget {
  final List<HeroInfo> roster;
  final int selectedIndex;
  final ValueChanged<int> onSelectHero;

  const CharacterRosterPanel({
    super.key,
    required this.roster,
    required this.selectedIndex,
    required this.onSelectHero,
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
            // Lưới 12 Anh Hùng: 3 Hàng x 4 Cột (Tăng kích thước ô và nhân vật)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Hàng 1: 4 Tướng đầu tiên (Pháp Sư & Hiệp Sĩ)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (col) {
                      final index = col;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onSelectHero(index),
                        size: 50,
                      );
                    }),
                  ),

                  // Hàng 2: 4 Tướng tiếp theo (Hiệp Sĩ & Samurai)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (col) {
                      final index = col + 4;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onSelectHero(index),
                        size: 50,
                      );
                    }),
                  ),

                  // Hàng 3: 4 Tướng cuối cùng (Samurai & Tử Linh)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (col) {
                      final index = col + 8;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onSelectHero(index),
                        size: 50,
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // Dòng tiêu đề đưa xuống dưới đáy bảng để vừa vặn trong lòng khung đá
            Container(
              height: 22,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CharacterSelectStrings.rosterSectionTitle,
                    style: GoogleFonts.cinzel(
                      color: const Color(0xFFFFD54F),
                      fontSize: 10,
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
                    style: GoogleFonts.cinzel(
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
