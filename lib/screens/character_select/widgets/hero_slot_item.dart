import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/hero_avatar_slot.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';

/// Ô chọn anh hùng trong bảng danh tướng
/// Bỏ khung viền vàng, dùng ô tối gọn gàng, tăng kích thước avatar, giữ glow boxshadow khi chọn
class HeroSlotItem extends StatelessWidget {
  final HeroInfo hero;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const HeroSlotItem({
    super.key,
    required this.hero,
    required this.isSelected,
    required this.onTap,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GamePressable(
      onTap: onTap,
      pressScale: 0.90,
      enableGlow: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected
              ? hero.primaryColor.withValues(alpha: 0.38)
              : const Color(0xD8161120),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD54F)
                : const Color(0xFF453650),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: hero.primaryColor.withValues(alpha: 0.85),
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
        child: Stack(
          children: [
            // Avatar chân dung pixel art kích thước lớn
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: HeroAvatarSlot(
                    characterType: hero.type,
                    primaryColor: hero.primaryColor,
                    isSelected: isSelected,
                  ),
                ),
              ),
            ),

            // Huy hiệu chức nghiệp ở góc trên bên trái
            Positioned(
              top: 2,
              left: 2,
              child: SelectPerWidget(
                tile: hero.badgeTile,
                width: 14,
                height: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
