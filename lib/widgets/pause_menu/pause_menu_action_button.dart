import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/constants/pause_menu_assets.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';

export 'package:fighting_game/constants/pause_menu_assets.dart';

/// Nút bấm theo asset ảnh cắt sẵn (resume.png, other_button.png) có 3D press effect
class PauseMenuActionButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color textColor;
  final double fontSize;

  const PauseMenuActionButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.icon,
    this.width = 210,
    this.height = 42,
    this.textColor = const Color(0xFFFFE082),
    this.fontSize = 12.0,
  });

  /// Nút Resume viền đỏ ruby hoàng kim
  factory PauseMenuActionButton.resume({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    double width = 210,
    double height = 42,
    double fontSize = 12.0,
  }) {
    return PauseMenuActionButton(
      imagePath: PauseMenuAssets.resumeButton,
      label: label,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      textColor: const Color(0xFFFFF176),
      fontSize: fontSize,
    );
  }

  /// Nút chức năng phụ viền đá tối (Chơi lại, Thoát)
  factory PauseMenuActionButton.secondary({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    double width = 210,
    double height = 42,
    double fontSize = 12.0,
    Color textColor = const Color(0xFFFFD54F),
  }) {
    return PauseMenuActionButton(
      imagePath: PauseMenuAssets.otherButton,
      label: label,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GamePressable(
      onTap: () {
        AudioService.playButtonClick();
        onTap();
      },
      pressDepth: 2.5,
      pressScale: 0.94,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 15,
                  color: textColor,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GameTypography.pixel(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                    Shadow(color: Color(0xFFE65100), blurRadius: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
