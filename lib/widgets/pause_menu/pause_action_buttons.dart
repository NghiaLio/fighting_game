import 'package:fighting_game/controllers/pause_menu_controller.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:flutter/material.dart';

/// Component UI: Danh sách các nút hành động xếp dọc (Tiếp tục, Chơi lại, Thoát)
class PauseActionButtons extends StatelessWidget {
  final PauseMenuController controller;

  const PauseActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. TIẾP TỤC (resume.png)
        PauseMenuActionButton.resume(
          label: 'TIẾP TỤC',
          icon: Icons.play_arrow_rounded,
          width: 190,
          height: 36,
          onTap: controller.resume,
        ),
        const SizedBox(height: 7),

        // 2. CHƠI LẠI (other_button.png)
        PauseMenuActionButton.secondary(
          label: 'CHƠI LẠI',
          icon: Icons.refresh_rounded,
          width: 190,
          height: 36,
          textColor: const Color(0xFFFFD54F),
          onTap: controller.restart,
        ),
        const SizedBox(height: 7),

        // 3. THOÁT (other_button.png)
        PauseMenuActionButton.secondary(
          label: 'THOÁT RA MENU',
          icon: Icons.home_rounded,
          width: 190,
          height: 36,
          textColor: const Color(0xFFFFAB91),
          onTap: controller.quitToHome,
        ),
      ],
    );
  }
}
