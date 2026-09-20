import 'package:fighting_game/controllers/settings_controller.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Component UI: Bảng điều chỉnh âm thanh (Nhạc nền & Hiệu ứng)
class PauseAudioPanel extends StatelessWidget {
  final SettingsController settingsCtrl;

  const PauseAudioPanel({super.key, required this.settingsCtrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSoundOn = settingsCtrl.soundEnabled.value;
      final bgm = settingsCtrl.bgmVolume.value;
      final sfx = settingsCtrl.sfxVolume.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nhạc Nền (BGM)
          _buildVolumeRow(
            context: context,
            title: 'NHẠC NỀN',
            value: isSoundOn ? bgm : 0.0,
            onChanged: isSoundOn
                ? (val) => settingsCtrl.setBgmVolume(val)
                : null,
          ),
          const SizedBox(height: 6),
          // Hiệu Ứng (SFX)
          _buildVolumeRow(
            context: context,
            title: 'HIỆU ỨNG',
            value: isSoundOn ? sfx : 0.0,
            onChanged: isSoundOn
                ? (val) => settingsCtrl.setSfxVolume(val)
                : null,
          ),
        ],
      );
    });
  }

  Widget _buildVolumeRow({
    required BuildContext context,
    required String title,
    required double value,
    required ValueChanged<double>? onChanged,
  }) {
    final isMuted = onChanged == null || value <= 0;

    return SizedBox(
      height: 28,
      child: Row(
        children: [
          // Nút Icon loa tắt/bật tiếng
          GamePressable(
            onTap: settingsCtrl.toggleSound,
            pressScale: 0.88,
            child: Opacity(
              opacity: isMuted ? 0.35 : 1.0,
              child: Image.asset(
                PauseMenuAssets.volumeIcon,
                width: 20,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Tên kênh âm thanh
          SizedBox(
            width: 64,
            child: Text(
              title,
              style: GoogleFonts.cinzel(
                color: isMuted ? Colors.white38 : const Color(0xFFFFD54F),
                fontSize: 9.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Thanh kéo âm lượng hoàng kim
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.5,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 5.5,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 9),
                activeTrackColor: const Color(0xFFFFD54F),
                inactiveTrackColor: const Color(0xFF3E2723),
                thumbColor: const Color(0xFFFFE082),
                disabledThumbColor: Colors.grey,
                disabledActiveTrackColor: Colors.white24,
                disabledInactiveTrackColor: Colors.black38,
              ),
              child: Slider(
                value: value.clamp(0.0, 1.0),
                onChanged: onChanged,
              ),
            ),
          ),

          // Phần trăm % âm lượng
          SizedBox(
            width: 28,
            child: Text(
              '${(value * 100).toInt()}%',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isMuted ? Colors.white38 : const Color(0xFFFFD54F),
                fontSize: 9.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
