import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/controllers/pause_menu_controller.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:flutter/material.dart';

/// Component UI: Danh sách các nút hành động xếp dọc (Tiếp tục, Chơi lại, Thoát)
class PauseActionButtons extends StatelessWidget {
  final PauseMenuController controller;

  const PauseActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const double btnWidth = 210;
    const double btnHeight = 42;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. TIẾP TỤC (resume.png)
        PauseMenuActionButton.resume(
          label: AppStrings.pauseResume,
          icon: Icons.play_arrow_rounded,
          width: btnWidth + 15,
          height: btnHeight + 5,
          onTap: controller.resume,
        ),
        const SizedBox(height: 10),

        // 2. CHƠI LẠI (other_button.png)
        PauseMenuActionButton.secondary(
          label: AppStrings.pauseRestart,
          icon: Icons.refresh_rounded,
          width: btnWidth,
          height: btnHeight,
          textColor: const Color(0xFFFFD54F),
          onTap: controller.restart,
        ),
        const SizedBox(height: 10),

        // 3. THOÁT (other_button.png)
        PauseMenuActionButton.secondary(
          label: AppStrings.pauseQuit,
          icon: Icons.home_rounded,
          width: btnWidth,
          height: btnHeight,
          textColor: const Color(0xFFFFAB91),
          onTap: controller.quitToHome,
        ),
      ],
    );
  }
}
