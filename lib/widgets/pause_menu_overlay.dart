import 'dart:ui';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/utils/pause_menu_tileset.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Overlay Menu Tạm Dừng (Pause Menu) cho trận đấu
/// - Bố cục dọc hoàn toàn theo tỷ lệ chuẩn của board_settings.png (527 x 598)
/// - Các phần âm thanh hòa quyện trực tiếp vào khung đá, không dùng khối nền phụ
/// - Nút Tiếp tục (resume.png), Chơi lại & Thoát (other_button.png) xếp dọc
class PauseMenuOverlay extends StatefulWidget {
  final FightingGame game;

  const PauseMenuOverlay({super.key, required this.game});

  @override
  State<PauseMenuOverlay> createState() => _PauseMenuOverlayState();
}

class _PauseMenuOverlayState extends State<PauseMenuOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  double _bgmVolume = AudioService.bgmVolume;
  double _sfxVolume = AudioService.sfxVolume;
  bool _soundEnabled = AudioService.soundEnabled;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onResume() {
    widget.game.overlays.remove('PauseMenu');
    widget.game.resumeEngine();
  }

  void _onRestart() {
    widget.game.overlays.remove('PauseMenu');
    widget.game.restartMatch();
    widget.game.resumeEngine();
  }

  void _onQuit() {
    widget.game.resumeEngine();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _toggleMute() {
    AudioService.playButtonClick();
    setState(() {
      _soundEnabled = !_soundEnabled;
      AudioService.soundEnabled = _soundEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Khung board_settings có tỉ lệ gốc 527 x 598 (gần 1 : 1.13)
    const double boardWidth = 330;
    const double boardHeight = 374;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
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
                            // Header tiêu đề TẠM DỪNG kèm nút setting.png hai bên
                            _buildHeader(),

                            // 2 Thanh điều khiển âm thanh xây dựng trực tiếp trong khung, không dùng nền phụ
                            _buildAudioControls(),

                            // Danh sách 3 nút hành động xếp theo chiều dọc
                            _buildVerticalActionButtons(),
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
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildAudioControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nhạc Nền (BGM)
        _buildVolumeRow(
          title: 'NHẠC NỀN',
          value: _soundEnabled ? _bgmVolume : 0.0,
          onChanged: _soundEnabled
              ? (val) {
                  setState(() {
                    _bgmVolume = val;
                    AudioService.bgmVolume = val;
                  });
                }
              : null,
        ),
        const SizedBox(height: 6),
        // Hiệu Ứng (SFX)
        _buildVolumeRow(
          title: 'HIỆU ỨNG',
          value: _soundEnabled ? _sfxVolume : 0.0,
          onChanged: _soundEnabled
              ? (val) {
                  setState(() {
                    _sfxVolume = val;
                    AudioService.sfxVolume = val;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildVolumeRow({
    required String title,
    required double value,
    required ValueChanged<double>? onChanged,
  }) {
    final isMuted = onChanged == null || value <= 0;

    return SizedBox(
      height: 28,
      child: Row(
        children: [
          // Icon volume.png bấm để bật/tắt mute
          GamePressable(
            onTap: _toggleMute,
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

          // Nhãn tên kênh âm thanh
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

          // Thanh Slider hoàng kim tinh tế
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
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

          // Số % âm lượng
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

  Widget _buildVerticalActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. TIẾP TỤC (resume.png)
        PauseMenuActionButton.resume(
          label: 'TIẾP TỤC',
          icon: Icons.play_arrow_rounded,
          width: 190,
          height: 36,
          onTap: _onResume,
        ),
        const SizedBox(height: 7),

        // 2. CHƠI LẠI (other_button.png)
        PauseMenuActionButton.secondary(
          label: 'CHƠI LẠI',
          icon: Icons.refresh_rounded,
          width: 190,
          height: 36,
          textColor: const Color(0xFFFFD54F),
          onTap: _onRestart,
        ),
        const SizedBox(height: 7),

        // 3. THOÁT (other_button.png)
        PauseMenuActionButton.secondary(
          label: 'THOÁT RA MENU',
          icon: Icons.home_rounded,
          width: 190,
          height: 36,
          textColor: const Color(0xFFFFAB91),
          onTap: _onQuit,
        ),
      ],
    );
  }
}
