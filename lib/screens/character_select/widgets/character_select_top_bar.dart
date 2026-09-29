import 'package:fighting_game/constants/app_strings.dart';
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
      children: [
        // Nút quay lại sảnh chính (Sử dụng slenderBarShort từ select_per)
        GamePressable(
          onTap: onBack,
          pressDepth: 2.0,
          pressScale: 0.90,
          child: SelectPerWidget(
            tile: SelectPerTile.slenderBarShort,
            width: 100,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Ui2FlagWidget(tile: Ui2FlagTile.arrowLeft, height: 14),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    AppStrings.charSelectHome,
                    style: GameTypography.pixel(
                      color: const Color(0xFFFFD54F),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Chế độ thi đấu (Sử dụng slenderBarShort từ select_per)
        SelectPerWidget(
          tile: SelectPerTile.slenderBarShort,
          width: 100,
          height: 40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                AppStrings.charSelectMode,
                style: GameTypography.pixel(
                  color: const Color(0xFFFFD54F),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
