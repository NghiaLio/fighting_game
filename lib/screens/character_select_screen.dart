import 'package:fighting_game/constants/character_select_strings.dart';
import 'package:fighting_game/constants/hero_roster_data.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/screens/character_select/widgets/character_monument_stage.dart';
import 'package:fighting_game/screens/character_select/widgets/character_roster_panel.dart';
import 'package:fighting_game/screens/character_select/widgets/character_select_top_bar.dart';
import 'package:fighting_game/screens/character_select/widgets/character_specs_panel.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// Màn hình chọn tướng (Character Select Screen)
/// Thiết kế Dark Fantasy theo kiến trúc phân tách module sạch,
/// khai thác tối đa tileset select_per.png kết hợp cờ gothic từ UI_tileset_2.png
class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  int _selectedIndex = 6; // Mặc định chọn Samurai Độc Hành (kHeroRoster[6])

  HeroInfo get _selectedHero => kHeroRoster[_selectedIndex];

  @override
  void initState() {
    super.initState();
    // Nạp sẵn toàn bộ hình ảnh tileset vào bộ nhớ GPU để render tức thì
    SelectPerTileset.preload();
  }

  void _onSelectHero(int index) {
    if (_selectedIndex == index) return;
    AudioService.playButtonClick();
    setState(() => _selectedIndex = index);
  }

  void _onBackToHome() {
    AudioService.playButtonClick();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _onConfirmHero() {
    AudioService.playButtonClick();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GamePlayScreen(
          playerCharacter: _selectedHero.type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hero = _selectedHero;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Phông nền Dark Fantasy
          Image.asset(
            'assets/images/Bg_homes/bg_home.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Lớp phủ Vignette tối điện ảnh
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),

          // 3. Rèm lụa đỏ trang trí đỉnh màn hình từ UI_tileset_2
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Ui2FlagWidget(
                tile: Ui2FlagTile.redDrapery,
                height: 22,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // 4. Thanh đỉnh (Top Bar)
          Positioned(
            top: 6,
            left: 16,
            right: 16,
            child: CharacterSelectTopBar(
              selectedHero: hero,
              onBack: _onBackToHome,
            ),
          ),

          // 5. Khu vực sân khấu 3 cột (Landscape Stage)
          Positioned(
            top: 50,
            bottom: 56,
            left: 12,
            right: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // CỘT 1 (TRÁI): Bảng Gothic Chamber chứa danh sách 12 anh hùng
                Expanded(
                  flex: 38,
                  child: CharacterRosterPanel(
                    roster: kHeroRoster,
                    selectedIndex: _selectedIndex,
                    onSelectHero: _onSelectHero,
                  ),
                ),

                const SizedBox(width: 8),

                // CỘT 2 (GIỮA): Võ đài tôn vinh anh hùng (Cột cờ nguyên tố & Idle 60fps)
                Expanded(
                  flex: 28,
                  child: CharacterMonumentStage(hero: hero),
                ),

                const SizedBox(width: 8),

                // CỘT 3 (PHẢI): Bảng thông số, 4 chỉ số và kỹ năng / tiểu sử
                Expanded(
                  flex: 34,
                  child: CharacterSpecsPanel(hero: hero),
                ),
              ],
            ),
          ),

          // 6. Nút "XUẤT TRẬN" bằng sprite nhọn từ select_per: buttonLong
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: SelectPerButton(
                tile: SelectPerTile.buttonLong,
                width: 280,
                height: 46,
                label: CharacterSelectStrings.confirmButton,
                icon: Icons.sports_kabaddi_rounded,
                onTap: _onConfirmHero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
