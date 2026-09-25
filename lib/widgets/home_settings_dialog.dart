import 'package:fighting_game/constants/app_strings.dart';
import 'package:fighting_game/constants/game_typography.dart';
import 'package:fighting_game/controllers/game_match_controller.dart';
import 'package:fighting_game/controllers/settings_controller.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dialog cài đặt âm thanh và tiến trình của màn hình chính.
class HomeSettingsDialog extends StatelessWidget {
  final Future<void> Function() onResetConfirmed;

  const HomeSettingsDialog({super.key, required this.onResetConfirmed});

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = SettingsController.to;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: UiTileWidget(
          tile: UiTile.hangingBoard,
          width: 480,
          height: 370,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(80, 120, 80, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.settingsTitle,
                  style: GameTypography.pixel(
                    color: const Color(0xFFFFD54F),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 6)],
                  ),
                ),
                // const SizedBox(height: 20),
                Obx(
                  () => _buildVolumeRow(
                    icon: Icons.music_note_rounded,
                    label: AppStrings.musicLabel,
                    value: settingsCtrl.bgmVolume.value,
                    onChanged: settingsCtrl.setBgmVolume,
                  ),
                ),
                Obx(
                  () => _buildVolumeRow(
                    icon: Icons.volume_up_rounded,
                    label: AppStrings.sfxLabel,
                    value: settingsCtrl.sfxVolume.value,
                    onChanged: settingsCtrl.setSfxVolume,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  final level = GameMatchController.to.currentLevel.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flag_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ROUND $level / 3',
                          style: GameTypography.pixel(
                            color: const Color(0xFFFFD54F),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UiTileButton(
                      tile: UiTile.shortButton,
                      label: 'RESET',
                      width: 120,
                      height: 42,
                      fontSize: 14,
                      textColor: const Color(0xFFEF9A9A),
                      onTap: _showResetConfirmation,
                    ),
                    const SizedBox(width: 16),
                    UiTileButton(
                      tile: UiTile.shortButton,
                      label: AppStrings.close,
                      width: 140,
                      height: 42,
                      fontSize: 14,
                      onTap: Get.back,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeRow({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        const SizedBox(width: 8),
        Text(
          label,
          style: GameTypography.pixel(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(
          width: 190,
          child: Slider(
            value: value,
            activeColor: const Color(0xFFFF9800),
            inactiveColor: Colors.black54,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showResetConfirmation() {
    Get.dialog(
      ResetProgressDialog(onConfirm: onResetConfirmed),
      barrierColor: Colors.black.withValues(alpha: 0.5),
    );
  }
}

class ResetProgressDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const ResetProgressDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'RESET?',
        style: GameTypography.pixel(
          color: const Color(0xFFFF8A80),
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Reset tiến trình về Round 1?',
        style: GameTypography.pixel(color: Colors.white70, fontSize: 12),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            'HỦY',
            style: GameTypography.pixel(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'RESET',
            style: GameTypography.pixel(
              color: const Color(0xFFFF8A80),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
