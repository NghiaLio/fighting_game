import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/constants/pause_menu_strings.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:flutter/material.dart';

/// Component UI: Tiêu đề PAUSED kèm huy hiệu bánh răng gothic đối xứng
class PauseHeader extends StatelessWidget {
  const PauseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          PauseMenuAssets.settingButton,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Text(
          PauseMenuStrings.title,
          style: GameTypography.pixel(
            color: const Color(0xFFFFD54F),
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
            shadows: const [
              Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
              Shadow(color: Color(0xFFE65100), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Image.asset(
          PauseMenuAssets.settingButton,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
