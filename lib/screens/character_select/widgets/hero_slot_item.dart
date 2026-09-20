import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_avatar_slot.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';

/// Ô chọn anh hùng trong bảng danh tướng
class HeroSlotItem extends StatelessWidget {
  final HeroInfo hero;
  final bool isSelected;
  final VoidCallback onTap;

  const HeroSlotItem({
    super.key,
    required this.hero,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GamePressable(
      onTap: onTap,
      pressScale: 0.88,
      enableGlow: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: hero.primaryColor.withValues(alpha: 0.9),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Color(0xFFFFD54F),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: SelectPerWidget(
          tile: SelectPerTile.squareSlotFrame,
          child: Padding(
            padding: const EdgeInsets.all(4.5),
            child: Stack(
              children: [
                // Avatar chân dung pixel art
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: HeroAvatarSlot(
                      characterType: hero.type,
                      primaryColor: hero.primaryColor,
                      isSelected: isSelected,
                    ),
                  ),
                ),

                // Huy hiệu chức nghiệp ở góc trên bên trái
                Positioned(
                  top: 0,
                  left: 0,
                  child: SelectPerWidget(
                    tile: hero.badgeTile,
                    width: 13,
                    height: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
