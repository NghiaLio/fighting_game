import 'package:fighting_game/constants/character_select_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';

/// Thanh đỉnh của màn hình chọn tướng: Nút quay lại, Cánh chim hoàng gia, Chế độ trận đấu
class CharacterSelectTopBar extends StatelessWidget {
  final HeroInfo selectedHero;
  final VoidCallback onBack;

  const CharacterSelectTopBar({
    super.key,
    required this.selectedHero,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Nút quay lại Trang chủ (Sử dụng slenderBarShort từ select_per)
        GamePressable(
          onTap: onBack,
          pressDepth: 2.0,
          pressScale: 0.94,
          child: SelectPerWidget(
            tile: SelectPerTile.slenderBarShort,
            width: 115,
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Ui2FlagWidget(
                  tile: Ui2FlagTile.arrowLeft,
                  height: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  CharacterSelectStrings.homeButton,
                  style: GameTypography.pixel(
                    color: const Color(0xFFFFD54F),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tiêu đề trung tâm: Cánh chim chữ V hoàng gia (wingsCrest từ select_per)
        SelectPerWidget(
          tile: SelectPerTile.wingsCrest,
          height: 44,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                CharacterSelectStrings.screenTitle,
                style: GameTypography.pixel(
                  color: const Color(0xFFFFD54F),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  shadows: const [
                    Shadow(color: Colors.black, blurRadius: 6),
                    Shadow(color: Color(0xFFE65100), blurRadius: 10),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Chế độ thi đấu (Sử dụng slenderBarShort từ select_per)
        SelectPerWidget(
          tile: SelectPerTile.slenderBarShort,
          width: 125,
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectPerWidget(
                tile: selectedHero.gemTile,
                height: 15,
              ),
              const SizedBox(width: 6),
              Text(
                CharacterSelectStrings.matchMode,
                style: GameTypography.pixel(
                  color: const Color(0xFFFFD54F),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
