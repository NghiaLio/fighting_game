import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Quản lý đường dẫn asset hình ảnh cho giao diện Pause Menu & Settings
class PauseMenuAssets {
  static const String boardSettings = 'assets/images/Bg_homes/board_settings.png';
  static const String otherButton = 'assets/images/Bg_homes/other_button.png';
  static const String resumeButton = 'assets/images/Bg_homes/resume.png';
  static const String volumeIcon = 'assets/images/Bg_homes/volume.png';
  static const String settingButton = 'assets/images/Buttons/setting.png';
}

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
    this.width = 175,
    this.height = 42,
    this.textColor = const Color(0xFFFFE082),
    this.fontSize = 12.0,
  });

  /// Nút Resume viền đỏ ruby hoàng kim
  factory PauseMenuActionButton.resume({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    double width = 175,
    double height = 42,
  }) {
    return PauseMenuActionButton(
      imagePath: PauseMenuAssets.resumeButton,
      label: label,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      textColor: const Color(0xFFFFF176),
      fontSize: 12.0,
    );
  }

  /// Nút chức năng phụ viền đá tối (Chơi lại, Thoát)
  factory PauseMenuActionButton.secondary({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    double width = 175,
    double height = 42,
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
      fontSize: 12.0,
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
                  shadows: const [
                    Shadow(color: Colors.black, blurRadius: 4),
                  ],
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.cinzel(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  shadows: const [
                    Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3),
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
