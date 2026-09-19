import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/utils/ui_tileset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _torchController;
  late Animation<double> _torchFlicker;

  // Sound settings state
  double _bgmVolume = 0.8;
  double _sfxVolume = 0.9;

  @override
  void initState() {
    super.initState();
    // Preload the tileset texture
    UiTileset.load();

    _torchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _torchFlicker = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _torchController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _torchController.dispose();
    super.dispose();
  }

  void _openSettings() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: UiTileWidget(
                  tile: UiTile.hangingBoard,
                  width: 480,
                  height: 310,
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 50, 48, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CÀI ĐẶT TRÒ CHƠI',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFFD54F),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nhạc nền BGM
                      Row(
                        children: [
                          const Icon(Icons.music_note_rounded,
                              color: Colors.amber, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Nhạc nền:',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _bgmVolume,
                              activeColor: const Color(0xFFFF9800),
                              inactiveColor: Colors.black54,
                              onChanged: (val) {
                                setDialogState(() => _bgmVolume = val);
                                setState(() => _bgmVolume = val);
                              },
                            ),
                          ),
                        ],
                      ),

                      // Âm thanh SFX
                      Row(
                        children: [
                          const Icon(Icons.volume_up_rounded,
                              color: Colors.amber, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Hiệu ứng:',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _sfxVolume,
                              activeColor: const Color(0xFFFF9800),
                              inactiveColor: Colors.black54,
                              onChanged: (val) {
                                setDialogState(() => _sfxVolume = val);
                                setState(() => _sfxVolume = val);
                              },
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Đóng
                      UiTileButton(
                        tile: UiTile.shortButton,
                        label: 'ĐÓNG',
                        width: 140,
                        height: 42,
                        fontSize: 13,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          },
        );
      },
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E140F),
        content: Text(
          '$title sẽ ra mắt ở phiên bản tiếp theo!',
          style: const TextStyle(
            color: Color(0xFFFFD54F),
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Scene (bg_home.png)
          Image.asset(
            'assets/images/Bg_homes/bg_home.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Cinematic Vignette
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),

          // 3. Top Header Bar (Currency & Logo & Profile)
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile Badge (using blueBanner + shortButton)
                Row(
                  children: [
                    const UiTileWidget(
                      tile: UiTile.blueBanner,
                      width: 44,
                      height: 55,
                    ),
                    const SizedBox(width: 8),
                    UiTileWidget(
                      tile: UiTile.shortButton,
                      width: 150,
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_rounded,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'CHIẾN BINH',
                              style: GoogleFonts.cinzel(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Top Center: Rèm rủ (redCurtain) + Logo VALOR AWAKENING
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        const UiTileWidget(
                          tile: UiTile.redCurtain,
                          width: 240,
                          height: 70,
                        ),
                        Positioned(
                          top: 12,
                          child: Image.asset(
                            'assets/images/Bg_homes/logo.png',
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Ruby Gem & Gold Coins (using rubyGem)
                Row(
                  children: [
                    UiTileWidget(
                      tile: UiTile.shortButton,
                      width: 130,
                      height: 38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const UiTileWidget(
                              tile: UiTile.rubyGem,
                              width: 20,
                              height: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '9,999',
                              style: GoogleFonts.cinzel(
                                color: const Color(0xFFFFD54F),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Quick settings button
                    GestureDetector(
                      onTap: _openSettings,
                      child: const UiTileWidget(
                        tile: UiTile.rubyGem,
                        width: 36,
                        height: 38,
                        child: Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Main Stage Area (Left Parchment Quest + Center Grand Menu Board)
          Positioned(
            top: size.height * 0.22,
            bottom: size.height * 0.06,
            left: 24,
            right: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Parchment Board (Quests & Progress)
                Flexible(
                  flex: 4,
                  child: UiTileWidget(
                    tile: UiTile.parchmentBoard,
                    height: (size.height * 0.65).clamp(240.0, 320.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 42, 36, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'CHIẾN DỊCH',
                              style: GoogleFonts.cinzel(
                                color: const Color(0xFF3E2723),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          const Divider(color: Color(0xFF8D6E63), thickness: 1.5),
                          const SizedBox(height: 6),
                          Text(
                            '• Màn hiện tại: MAP 1 (Rừng Xanh)',
                            style: GoogleFonts.medievalSharp(
                              color: const Color(0xFF4E342E),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Đối thủ: Hiệp Sĩ Thiết Giáp',
                            style: GoogleFonts.medievalSharp(
                              color: const Color(0xFF4E342E),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Thể thức: 3 Round tử chiến',
                            style: GoogleFonts.medievalSharp(
                              color: const Color(0xFFB71C1C),
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4E342E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'TIẾN ĐỘ: 0 / 7 MAPS',
                                style: GoogleFonts.cinzel(
                                  color: const Color(0xFFFFD54F),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Center/Right: Grand Board with Torches (Main Menu)
                Flexible(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Grand Board frame with flaming torches
                      AnimatedBuilder(
                        animation: _torchFlicker,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6F00)
                                      .withValues(alpha: 0.25 * _torchFlicker.value),
                                  blurRadius: 30,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: UiTileWidget(
                          tile: UiTile.grandBoard,
                          height: (size.height * 0.72).clamp(280.0, 360.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Nút Bắt Đầu Chiến Đấu
                                UiTileButton(
                                  tile: UiTile.ornatePlaque,
                                  label: 'CHIẾN ĐẤU NGAY',
                                  icon: Icons.sports_kabaddi_rounded,
                                  width: 290,
                                  height: 60,
                                  fontSize: 16,
                                  textColor: const Color(0xFFFFD54F),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const GamePlayScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),

                                // Nút Chọn Anh Hùng
                                UiTileButton(
                                  tile: UiTile.longButton,
                                  label: 'ANH HÙNG (12)',
                                  icon: Icons.shield_rounded,
                                  width: 250,
                                  height: 48,
                                  fontSize: 13,
                                  textColor: Colors.amber.shade200,
                                  onTap: () => _showComingSoon('Kho Anh Hùng'),
                                ),
                                const SizedBox(height: 8),

                                // Nút Cài Đặt
                                UiTileButton(
                                  tile: UiTile.longButton,
                                  label: 'CÀI ĐẶT',
                                  icon: Icons.settings_rounded,
                                  width: 250,
                                  height: 48,
                                  fontSize: 13,
                                  textColor: Colors.amber.shade200,
                                  onTap: _openSettings,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Corner Atmosphere: Lantern Pillar on the bottom right
          Positioned(
            bottom: -20,
            right: 16,
            child: Opacity(
              opacity: 0.85,
              child: UiTileWidget(
                tile: UiTile.lanternPillar,
                width: 90,
                height: 130,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
