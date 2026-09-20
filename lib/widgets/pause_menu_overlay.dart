import 'dart:ui';
import 'package:fighting_game/controllers/pause_menu_controller.dart';
import 'package:fighting_game/controllers/settings_controller.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:fighting_game/widgets/pause_menu/pause_action_buttons.dart';
import 'package:fighting_game/widgets/pause_menu/pause_audio_panel.dart';
import 'package:fighting_game/widgets/pause_menu/pause_header.dart';
import 'package:flutter/material.dart';

/// Overlay Menu Tạm Dừng (Pause Menu) cho trận đấu
/// - Kiến trúc Clean Code: Phân tách 100% giữa View (UI) và Controller (Logic)
/// - Toàn bộ sự kiện hành động (resume, restart, quit) ủy quyền cho [PauseMenuController]
/// - Toàn bộ reactive audio state quản lý bởi [SettingsController]
/// - Giao diện phân tách thành các component độc lập: [PauseHeader], [PauseAudioPanel], [PauseActionButtons]
class PauseMenuOverlay extends StatelessWidget {
  final FightingGame game;

  const PauseMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const double boardWidth = 330;
    const double boardHeight = 374;

    // Khởi tạo/Lấy Controller xử lý nghiệp vụ
    final pauseCtrl = PauseMenuController(game: game);
    final settingsCtrl = SettingsController.to;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Khung nền chính (board_settings.png)
                  Positioned.fill(
                    child: Image.asset(
                      PauseMenuAssets.boardSettings,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // 2. Nội dung bố cục dọc bên trong khung đá
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 26, 36, 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // UI Component 1: Tiêu đề
                          const PauseHeader(),

                          // UI Component 2: Bảng điều chỉnh âm lượng
                          PauseAudioPanel(settingsCtrl: settingsCtrl),

                          // UI Component 3: Hàng nút bấm hành động
                          PauseActionButtons(controller: pauseCtrl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
