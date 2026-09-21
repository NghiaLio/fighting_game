import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_stat_bar.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// Cột phải: Bảng thông số và kỹ năng từ select_per (Tên, 4 chỉ số chiến đấu, tuyệt kỹ & tiểu sử)
class CharacterSpecsPanel extends StatelessWidget {
  final HeroInfo hero;

  const CharacterSpecsPanel({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Tấm phù điêu kiếm thần (wideTitleBar): Tên & Danh hiệu
        SizedBox(
          height: 60,
          child: SelectPerWidget(
            tile: SelectPerTile.wideTitleBar,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 6, 12, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hero.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GameTypography.pixel(
                      color: const Color(0xFFFFD54F),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 4),
                      ],
                    ),
                  ),
                  Text(
                    hero.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GameTypography.pixel(
                      color: hero.primaryColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        // 2. Bảng đá 4 chỉ số chiến đấu (statTablet4Lines): ATK, DEF, SPD, RNG
        Expanded(
          flex: 6,
          child: SelectPerWidget(
            tile: SelectPerTile.statTablet4Lines,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HeroStatBar(
                    label: AppStrings.statAttack,
                    value: hero.atkRating,
                    color: const Color(0xFFFF5252),
                    icon: Icons.flash_on_rounded,
                  ),
                  HeroStatBar(
                    label: AppStrings.statDefense,
                    value: hero.defRating,
                    color: const Color(0xFF42A5F5),
                    icon: Icons.shield_rounded,
                  ),
                  HeroStatBar(
                    label: AppStrings.statSpeed,
                    value: hero.spdRating,
                    color: const Color(0xFFFFCA28),
                    icon: Icons.speed_rounded,
                  ),
                  HeroStatBar(
                    label: AppStrings.statRange,
                    value: hero.rngRating,
                    color: const Color(0xFFAB47BC),
                    icon: Icons.track_changes_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        // 3. Bảng đá thông tin chiêu thức & tiểu sử (statTablet3Lines)
        Expanded(
          flex: 5,
          child: SelectPerWidget(
            tile: SelectPerTile.statTablet3Lines,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                         Icons.auto_awesome_rounded,
                        color: Color(0xFFFFD54F),
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.ultimatePrefix,
                        style: GameTypography.pixel(
                          color: const Color(0xFFFFD54F),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          hero.ultimateName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GameTypography.pixel(
                            color: Colors.amber.shade200,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        hero.description,
                        style: GameTypography.pixel(
                          color: Colors.white70,
                          fontSize: 10.0,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
