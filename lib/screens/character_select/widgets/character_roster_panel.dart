import 'package:fighting_game/constants/character_select_strings.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_slot_item.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cột trái: Bảng lớn Gothic Chamber chứa danh sách 12 anh hùng (2 hàng x 6 tướng)
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
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Column(
          children: [
            // Tiêu đề bảng
            Text(
              CharacterSelectStrings.rosterSectionTitle,
              style: GoogleFonts.cinzel(
                color: const Color(0xFFFFD54F),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: const [
                  Shadow(color: Colors.black, blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Lưới 12 Anh Hùng: 2 Hàng x 6 Cột
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Hàng 1: 6 Pháp Sư & Hiệp Sĩ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(6, (col) {
                      final index = col;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onSelectHero(index),
                      );
                    }),
                  ),

                  // Hàng 2: 6 Samurai & Tử Linh
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(6, (col) {
                      final index = col + 6;
                      return HeroSlotItem(
                        hero: roster[index],
                        isSelected: index == selectedIndex,
                        onTap: () => onSelectHero(index),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Tấm nhãn chân bảng: Tên & chức nghiệp tướng đang chọn
            Container(
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              alignment: Alignment.center,
              child: Text(
                '• ${_selectedHero.name} [${_selectedHero.shortRole}] •',
                style: GoogleFonts.cinzel(
                  color: _selectedHero.primaryColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
