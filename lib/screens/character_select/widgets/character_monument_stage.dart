import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_idle_preview.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// Cột giữa: Võ đài tôn vinh anh hùng (Cột cờ nguyên tố, cờ kiếm gothic, hoạt ảnh idle 60fps)
class CharacterMonumentStage extends StatelessWidget {
  final HeroInfo hero;

  const CharacterMonumentStage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Cột đá nguyên tố cao lớn phía sau lưng nhân vật từ select_per
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: SelectPerWidget(
            key: ValueKey(hero.pillarTile),
            tile: hero.pillarTile,
            height: 235,
            fit: BoxFit.contain,
          ),
        ),

        // Cờ kiếm Gothic từ UI_tileset_2 rủ hai bên cánh
        const Positioned(
          left: 2,
          top: 15,
          child: Opacity(
            opacity: 0.9,
            child: Ui2FlagWidget(tile: Ui2FlagTile.redGothicBanner, height: 88),
          ),
        ),
        const Positioned(
          right: 2,
          top: 15,
          child: Opacity(
            opacity: 0.9,
            child: Ui2FlagWidget(
              tile: Ui2FlagTile.blueGothicBanner,
              height: 88,
            ),
          ),
        ),

        // Bệ đài ma thuật phát quang dưới chân
        Positioned(
          bottom: 6,
          child: Container(
            width: 140,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: hero.primaryColor.withValues(alpha: 0.8),
                  blurRadius: 26,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),

        // Nhân vật Pixel Art khổng lồ chạy hoạt ảnh Idle
        Positioned(
          bottom: 8,
          child: HeroIdlePreview(
            key: ValueKey(hero.type),
            characterType: hero.type,
            frameCount: hero.idleFrames,
            size: 250,
          ),
        ),

        // Phù hiệu vai trò và ngọc hệ nổi trên đỉnh đầu (barDiamond từ select_per)
        Positioned(
          top: 0,
          child: SelectPerWidget(
            tile: SelectPerTile.wideTitleBar,
            width: 150,
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  hero.name,
                  style: GameTypography.pixel(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
