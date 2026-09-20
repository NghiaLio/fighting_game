import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Component UI: Tiêu đề TẠM DỪNG kèm huy hiệu bánh răng gothic đối xứng
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
          'TẠM DỪNG',
          style: GoogleFonts.cinzel(
            color: const Color(0xFFFFD54F),
            fontSize: 15,
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
