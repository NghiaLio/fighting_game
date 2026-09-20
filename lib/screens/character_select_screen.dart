import 'dart:ui' as ui;
import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/screens/game_play_screen.dart';
import 'package:fighting_game/screens/home_screen.dart';
import 'package:fighting_game/services/audio_service.dart';
import 'package:fighting_game/widgets/game_pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thông tin chi tiết của 12 anh hùng
class HeroInfo {
  final CharacterType type;
  final String name;
  final String title;
  final String role;
  final String pillarAsset;
  final String badgeAsset;
  final String gemAsset;
  final Color primaryColor;
  final double atkRating;
  final double defRating;
  final double spdRating;
  final double rngRating;
  final String ultimateName;
  final String description;
  final int idleFrames;

  const HeroInfo({
    required this.type,
    required this.name,
    required this.title,
    required this.role,
    required this.pillarAsset,
    required this.badgeAsset,
    required this.gemAsset,
    required this.primaryColor,
    required this.atkRating,
    required this.defRating,
    required this.spdRating,
    required this.rngRating,
    required this.ultimateName,
    required this.description,
    required this.idleFrames,
  });
}

/// Danh sách 12 anh hùng chia làm 2 phe/hàng:
/// Hàng 1: Pháp Sư & Hiệp Sĩ (Mages & Knights)
/// Hàng 2: Samurai & Quỷ Cốt (Samurais & Skeletons)
final List<HeroInfo> kHeroRoster = [
  // --- HÀNG 1: PHÁP SƯ & HIỆP SĨ ---
  const HeroInfo(
    type: CharacterType.fireWizard,
    name: 'HỎA DIỆM PHÁP SƯ',
    title: 'Hỏa Long Tôn Giả (Ignis)',
    role: 'Pháp Sư - Hỏa Lực',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_red.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_crown.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFFFF5722),
    atkRating: 0.95,
    defRating: 0.50,
    spdRating: 0.70,
    rngRating: 0.95,
    ultimateName: 'Hỏa Long Bộc Phá',
    description: 'Sở hữu ngọn lửa cổ xưa thiêu rụi mọi phòng ngự. Cầu lửa có tầm bắn toàn màn hình.',
    idleFrames: 7,
  ),
  const HeroInfo(
    type: CharacterType.lightningWizard,
    name: 'LÔI ĐIỆN PHÁP SƯ',
    title: 'Cuồng Lôi Tiên Sinh (Voltis)',
    role: 'Pháp Sư - Khống Chế',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_blue.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_crown.png',
    gemAsset: 'assets/images/Bg_homes/ui2/sapphire_diamond.png',
    primaryColor: Color(0xFF00E5FF),
    atkRating: 0.90,
    defRating: 0.55,
    spdRating: 0.85,
    rngRating: 0.88,
    ultimateName: 'Thiên Lôi Giáng Lâm',
    description: 'Tốc độ xuất chiêu cực nhanh như tia chớp, giật điện làm tê liệt kẻ thù tức khắc.',
    idleFrames: 7,
  ),
  const HeroInfo(
    type: CharacterType.wandererMagician,
    name: 'LÃNG KHÁCH PHÁP SƯ',
    title: 'Bí Ẩn Hư Không (Aether)',
    role: 'Pháp Sư - Hư Không',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_purple.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_crown.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFFAB47BC),
    atkRating: 0.85,
    defRating: 0.60,
    spdRating: 0.80,
    rngRating: 0.90,
    ultimateName: 'Hư Không Trảm Kích',
    description: 'Bậc thầy thuật không gian, biến ảo khôn lường và tạo vết nứt hủy diệt tầm xa.',
    idleFrames: 8,
  ),
  const HeroInfo(
    type: CharacterType.knight1,
    name: 'THÁNH HIỆP SĨ',
    title: 'Kỵ Sĩ Ánh Sáng (Arthur)',
    role: 'Đỡ Đòn - Toàn Diện',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_red.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_shield.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFFFFD54F),
    atkRating: 0.80,
    defRating: 0.92,
    spdRating: 0.65,
    rngRating: 0.60,
    ultimateName: 'Thánh Kiếm Phán Quyết',
    description: 'Giáp thép kiên cố cùng khiên thần hộ mệnh. Sát thương phản hồi cực kỳ kinh hoàng.',
    idleFrames: 4,
  ),
  const HeroInfo(
    type: CharacterType.knight2,
    name: 'HOÀNG GIA HIỆP SĨ',
    title: 'Thanh Kiếm Vương Triều (Galahad)',
    role: 'Đấu Sĩ - Tiên Phong',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_blue.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_shield.png',
    gemAsset: 'assets/images/Bg_homes/ui2/sapphire_diamond.png',
    primaryColor: Color(0xFF42A5F5),
    atkRating: 0.85,
    defRating: 0.80,
    spdRating: 0.75,
    rngRating: 0.65,
    ultimateName: 'Hoàng Gia Đột Kích',
    description: 'Tướng tiên phong của vương quốc, sở hữu những đòn xông trận dũng mãnh và kiếm thuật thép.',
    idleFrames: 4,
  ),
  const HeroInfo(
    type: CharacterType.knight3,
    name: 'HẮC HIỆP SĨ',
    title: 'Hắc Giáp Tử Thần (Mordred)',
    role: 'Đấu Sĩ - Bạo Lực',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_purple.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_shield.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFF8E24AA),
    atkRating: 0.92,
    defRating: 0.85,
    spdRating: 0.60,
    rngRating: 0.65,
    ultimateName: 'Hắc Long Trọng Trảm',
    description: 'Kỵ sĩ bóng đêm với thanh đại kiếm khổng lồ, nghiền nát mọi tuyến phòng ngự.',
    idleFrames: 4,
  ),

  // --- HÀNG 2: SAMURAI & TỬ LINH ---
  const HeroInfo(
    type: CharacterType.samurai,
    name: 'SAMURAI ĐỘC HÀNH',
    title: 'Phong Kiếm Tuyệt Luân (Kenji)',
    role: 'Sát Thủ - Bão Kiếm',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_red.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_swords.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFFFF1744),
    atkRating: 0.96,
    defRating: 0.58,
    spdRating: 0.95,
    rngRating: 0.70,
    ultimateName: 'Vô Cực Tuyệt Kiếm',
    description: 'Đao pháp xuất quỷ nhập thần với tốc độ ánh sáng. Chuỗi liên hoàn kiếm hạ gục kẻ địch tức thì.',
    idleFrames: 6,
  ),
  const HeroInfo(
    type: CharacterType.samuraiArcher,
    name: 'SAMURAI CUNG THỦ',
    title: 'Tật Phong Thần Tiễn (Hanzo)',
    role: 'Xạ Thủ - Tầm Xa',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_green.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_swords.png',
    gemAsset: 'assets/images/Bg_homes/ui2/emerald_diamond.png',
    primaryColor: Color(0xFF00E676),
    atkRating: 0.88,
    defRating: 0.50,
    spdRating: 0.90,
    rngRating: 0.98,
    ultimateName: 'Bão Tiễn Đoạt Mạng',
    description: 'Bách phát bách trúng ở cự ly xa. Mũi tên xé gió giữ khoảng cách giao tranh an toàn.',
    idleFrames: 9,
  ),
  const HeroInfo(
    type: CharacterType.samuraiCommander,
    name: 'SAMURAI THỐNG LĨNH',
    title: 'Chiến Tướng Bá Đạo (Nobunaga)',
    role: 'Đấu Sĩ - Uy Áp',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_blue.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_swords.png',
    gemAsset: 'assets/images/Bg_homes/ui2/sapphire_diamond.png',
    primaryColor: Color(0xFF1E88E5),
    atkRating: 0.90,
    defRating: 0.78,
    spdRating: 0.80,
    rngRating: 0.72,
    ultimateName: 'Thiên Hạ Bá Quyền',
    description: 'Thống soái trận tiền sở hữu nhát chém khí phách ngút trời, xoay chuyển cục diện trận chiến.',
    idleFrames: 5,
  ),
  const HeroInfo(
    type: CharacterType.skeletonWarrior,
    name: 'TỬ LINH CHIẾN BINH',
    title: 'Hài Cốt Trỗi Dậy (Krag)',
    role: 'Đấu Sĩ - Bất Tử',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_purple.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_skull.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFF9C27B0),
    atkRating: 0.82,
    defRating: 0.75,
    spdRating: 0.75,
    rngRating: 0.65,
    ultimateName: 'Oán Hồn Bùng Nổ',
    description: 'Chiến binh từ cõi âm không biết đau đớn, liên tục ép sân bằng những cú bổ kiếm tàn bạo.',
    idleFrames: 7,
  ),
  const HeroInfo(
    type: CharacterType.skeletonArcher,
    name: 'TỬ LINH XẠ THỦ',
    title: 'Tử Xạ Hư Không (Skel\'Arch)',
    role: 'Xạ Thủ - Độc Dược',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_green.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_skull.png',
    gemAsset: 'assets/images/Bg_homes/ui2/emerald_diamond.png',
    primaryColor: Color(0xFF43A047),
    atkRating: 0.85,
    defRating: 0.45,
    spdRating: 0.88,
    rngRating: 0.95,
    ultimateName: 'Mũi Tên Hắc Ám',
    description: 'Tung ra những phát bắn mang độc tố tử linh, làm chậm và rút kiệt sinh lực đối phương.',
    idleFrames: 7,
  ),
  const HeroInfo(
    type: CharacterType.skeletonSpearman,
    name: 'TỬ LINH THƯƠNG THỦ',
    title: 'Trường Thương Địa Ngục (Spearhead)',
    role: 'Đấu Sĩ - Đột Kích',
    pillarAsset: 'assets/images/Bg_homes/ui2/hero_pillar_red.png',
    badgeAsset: 'assets/images/Bg_homes/ui2/badge_skull.png',
    gemAsset: 'assets/images/Bg_homes/ui2/ruby_diamond.png',
    primaryColor: Color(0xFFE53935),
    atkRating: 0.86,
    defRating: 0.70,
    spdRating: 0.82,
    rngRating: 0.80,
    ultimateName: 'Xung Kích Tử Thần',
    description: 'Tầm đâm trường thương cực dài và hiểm hóc, xuyên thủng mọi lớp giáp kiên cố.',
    idleFrames: 7,
  ),
];

/// Màn hình chọn tướng thiết kế từ nguyên mẫu Tileset 2
class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  int _selectedIndex = 6; // Mặc định chọn Kiếm Khách Samurai (hoặc 0)

  HeroInfo get _selectedHero => kHeroRoster[_selectedIndex];

  void _onSelectHero(int index) {
    if (_selectedIndex == index) return;
    AudioService.playButtonClick();
    setState(() => _selectedIndex = index);
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

          // 3. Rèm lụa đỏ trang trí đỉnh màn hình (red_drapery.png)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/Bg_homes/ui2/red_drapery.png',
                height: 24,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // 4. Thanh đỉnh (Top Bar)
          Positioned(
            top: 6,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nút quay lại Trang chủ (Sử dụng double_slot.png từ tileset)
                GamePressable(
                  onTap: () {
                    AudioService.playButtonClick();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  pressDepth: 2.0,
                  pressScale: 0.94,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Bg_homes/ui2/double_slot.png',
                        height: 34,
                        width: 110,
                        fit: BoxFit.fill,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/Bg_homes/ui2/arrow_left.png',
                            height: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'TRANG CHỦ',
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFFFD54F),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tiêu đề trung tâm: Cánh chim chữ V hoàng gia (valor_wings_crest.png)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Bg_homes/ui2/valor_wings_crest.png',
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'CHỌN ANH HÙNG',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFFD54F),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 6),
                            Shadow(color: Color(0xFFE65100), blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Chế độ thi đấu (Sử dụng double_slot.png từ tileset)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Bg_homes/ui2/double_slot.png',
                      height: 34,
                      width: 120,
                      fit: BoxFit.fill,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          hero.gemAsset,
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '1 VS 1 TỬ CHIẾN',
                          style: GoogleFonts.cinzel(
                            color: const Color(0xFFFFD54F),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 5. Khu Vực Chính 3 Phần Hài Hòa (Landscape Stage)
          Positioned(
            top: 56,
            bottom: 58,
            left: 14,
            right: 14,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // =============================================================
                // PHẦN 1 (TRÁI): BẢNG GOTHIC ROSTER BOARD TỪ TILESET (2 HÀNG x 6 Ô)
                // =============================================================
                Expanded(
                  flex: 38,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Khung đá lớn chính gốc từ tileset (roster_grid_board.png)
                      Image.asset(
                        'assets/images/Bg_homes/ui2/roster_grid_board.png',
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                      // Nội dung lồng chuẩn xác vào lòng khung đá
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
                        child: Column(
                          children: [
                            // Header tiêu đề nhỏ trong khung
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'DANH TƯỚNG HOÀNG GIA (12)',
                                  style: GoogleFonts.cinzel(
                                    color: const Color(0xFFFFD54F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    shadows: const [
                                      Shadow(color: Colors.black, blurRadius: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Lưới 12 Anh Hùng: 2 Hàng x 6 Cột chuẩn mực
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Hàng 1: 6 Pháp Sư & Hiệp Sĩ
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: List.generate(6, (col) {
                                      final index = col;
                                      return _buildHeroSlot(index);
                                    }),
                                  ),

                                  // Hàng 2: 6 Samurai & Tử Linh
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: List.generate(6, (col) {
                                      final index = col + 6;
                                      return _buildHeroSlot(index);
                                    }),
                                  ),
                                ],
                              ),
                            ),

                            // Tấm phù hiệu chân bảng: Tên tướng đang chọn
                            Container(
                              height: 22,
                              margin: const EdgeInsets.only(top: 4),
                              alignment: Alignment.center,
                              child: Text(
                                '• ${hero.name} [${hero.role.split(' - ').first}] •',
                                style: GoogleFonts.cinzel(
                                  color: hero.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // =============================================================
                // PHẦN 2 (GIỮA): VÕ ĐÀI TÔN VINH ANH HÙNG (HERO MONUMENT SHOWCASE)
                // =============================================================
                Expanded(
                  flex: 28,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cột cờ nguyên tố cao lớn phía sau lưng nhân vật
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Image.asset(
                          hero.pillarAsset,
                          key: ValueKey(hero.pillarAsset),
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Cờ kiếm Gothic rủ hai bên cánh
                      Positioned(
                        left: 0,
                        top: 15,
                        child: Opacity(
                          opacity: 0.85,
                          child: Image.asset(
                            'assets/images/Bg_homes/ui2/red_gothic_banner.png',
                            height: 95,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: Opacity(
                          opacity: 0.85,
                          child: Image.asset(
                            'assets/images/Bg_homes/ui2/blue_gothic_banner.png',
                            height: 95,
                          ),
                        ),
                      ),

                      // Bệ đài đá rune ma thuật phát quang dưới chân
                      Positioned(
                        bottom: 8,
                        child: Container(
                          width: 150,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: hero.primaryColor.withValues(alpha: 0.6),
                                blurRadius: 28,
                                spreadRadius: 6,
                              ),
                            ],
                            border: Border.all(
                              color: hero.primaryColor.withValues(alpha: 0.9),
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),

                      // Nhân vật Pixel Art khổng lồ (200px) chạy hoạt ảnh Idle 60fps
                      Positioned(
                        bottom: 12,
                        child: HeroIdlePreview(
                          key: ValueKey(hero.type),
                          characterType: hero.type,
                          frameCount: hero.idleFrames,
                          size: 200,
                        ),
                      ),

                      // Phù hiệu vai trò và ngọc hệ nổi trên đầu
                      Positioned(
                        top: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Bg_homes/ui2/double_slot.png',
                              height: 30,
                              width: 130,
                              fit: BoxFit.fill,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  hero.gemAsset,
                                  height: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  hero.role,
                                  style: GoogleFonts.cinzel(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // =============================================================
                // PHẦN 3 (PHẢI): BẢNG KHẮC ĐÁ THÔNG SỐ & KỸ NĂNG TỪ TILESET
                // =============================================================
                Expanded(
                  flex: 34,
                  child: Column(
                    children: [
                      // 1. Tấm phù điêu kiếm thần (wide_sword_plaque.png): Tên & Danh hiệu
                      SizedBox(
                        height: 68,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/Bg_homes/ui2/wide_sword_plaque.png',
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(48, 8, 14, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    hero.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.cinzel(
                                      color: const Color(0xFFFFD54F),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      shadows: const [
                                        Shadow(color: Colors.black, blurRadius: 4),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    hero.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.medievalSharp(
                                      color: hero.primaryColor,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 2. Bảng đá 4 chỉ số chiến đấu (top_info_panel.png): ATK, DEF, SPD, RNG
                      Expanded(
                        flex: 6,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/Bg_homes/ui2/top_info_panel.png',
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _StatBar(
                                    label: 'TẤN CÔNG',
                                    value: hero.atkRating,
                                    color: const Color(0xFFFF5252),
                                    icon: Icons.flash_on_rounded,
                                  ),
                                  _StatBar(
                                    label: 'PHÒNG THỦ',
                                    value: hero.defRating,
                                    color: const Color(0xFF42A5F5),
                                    icon: Icons.shield_rounded,
                                  ),
                                  _StatBar(
                                    label: 'TỐC ĐỘ',
                                    value: hero.spdRating,
                                    color: const Color(0xFFFFCA28),
                                    icon: Icons.speed_rounded,
                                  ),
                                  _StatBar(
                                    label: 'TẦM ĐÁNH',
                                    value: hero.rngRating,
                                    color: const Color(0xFFAB47BC),
                                    icon: Icons.track_changes_rounded,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 3. Bảng đá thông tin chiêu thức & tiểu sử (bottom_info_panel.png)
                      Expanded(
                        flex: 5,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/Bg_homes/ui2/bottom_info_panel.png',
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded,
                                          color: Color(0xFFFFD54F), size: 14),
                                      const SizedBox(width: 5),
                                      Text(
                                        'TUYỆT KỸ: ',
                                        style: GoogleFonts.cinzel(
                                          color: const Color(0xFFFFD54F),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          hero.ultimateName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.medievalSharp(
                                            color: Colors.amber.shade200,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        hero.description,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          height: 1.3,
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Nút "XUẤT TRẬN" bằng sprite từ UI_tileset_2: long_pointed_button
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Center(
              child: GamePressable(
                onTap: _onConfirmHero,
                pressDepth: 3.5,
                pressScale: 0.94,
                child: SizedBox(
                  width: 290,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Nền nút nhọn đính ngọc đỏ từ Tileset 2
                      Image.asset(
                        'assets/images/Bg_homes/ui2/long_pointed_button.png',
                        width: 290,
                        height: 48,
                        fit: BoxFit.fill,
                      ),

                      // Chữ hành động
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.sports_kabaddi_rounded,
                            size: 18,
                            color: Color(0xFFFFD54F),
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'XUẤT TRẬN',
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFFFD54F),
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3,
                                ),
                                Shadow(
                                  color: Color(0xFFE65100),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng ô tướng trong bảng roster board
  Widget _buildHeroSlot(int index) {
    final item = kHeroRoster[index];
    final isSelected = index == _selectedIndex;

    return GamePressable(
      onTap: () => _onSelectHero(index),
      pressScale: 0.88,
      enableGlow: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 42,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? item.primaryColor.withValues(alpha: 0.45)
              : const Color(0xD0120D1A),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFF5D4037),
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: item.primaryColor.withValues(alpha: 0.85),
                    blurRadius: 10,
                    spreadRadius: 1.5,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Ảnh chân dung nhân vật
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: HeroAvatarSlot(
                  characterType: item.type,
                  primaryColor: item.primaryColor,
                  isSelected: isSelected,
                ),
              ),
            ),

            // Huy hiệu chức nghiệp góc trên trái (badge từ tileset 2)
            Positioned(
              top: 1.5,
              left: 1.5,
              child: Image.asset(
                item.badgeAsset,
                width: 12,
                height: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thanh hiển thị chỉ số sức mạnh trong bảng đá top_info_panel
class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: GoogleFonts.cinzel(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 8,
              color: Colors.black.withValues(alpha: 0.65),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.6),
                            color,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 22,
          child: Text(
            '${(value * 100).toInt()}',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

/// Ô avatar chân dung pixel art trong danh sách 12 tướng
class HeroAvatarSlot extends StatefulWidget {
  final CharacterType characterType;
  final Color primaryColor;
  final bool isSelected;

  const HeroAvatarSlot({
    super.key,
    required this.characterType,
    required this.primaryColor,
    required this.isSelected,
  });

  @override
  State<HeroAvatarSlot> createState() => _HeroAvatarSlotState();
}

class _HeroAvatarSlotState extends State<HeroAvatarSlot> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadSprite();
  }

  Future<void> _loadSprite() async {
    try {
      final path = 'assets/images/${widget.characterType.spritePath}/Idle.png';
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() => _image = frame.image);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return Container(
        color: const Color(0xFF1B1622),
        child: const Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.amber),
          ),
        ),
      );
    }

    return CustomPaint(
      painter: _FirstFramePainter(image: _image!),
    );
  }
}

class _FirstFramePainter extends CustomPainter {
  final ui.Image image;
  _FirstFramePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    const srcRect = Rect.fromLTWH(0, 0, 128, 128);
    final dstRect = Offset.zero & size;
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _FirstFramePainter oldDelegate) =>
      oldDelegate.image != image;
}

/// Hoạt ảnh Idle pixel art chạy liên tục trên sân khấu
class HeroIdlePreview extends StatefulWidget {
  final CharacterType characterType;
  final int frameCount;
  final double size;

  const HeroIdlePreview({
    super.key,
    required this.characterType,
    required this.frameCount,
    required this.size,
  });

  @override
  State<HeroIdlePreview> createState() => _HeroIdlePreviewState();
}

class _HeroIdlePreviewState extends State<HeroIdlePreview>
    with SingleTickerProviderStateMixin {
  ui.Image? _image;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 140 * widget.frameCount),
    )..repeat();

    _loadSprite();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSprite() async {
    try {
      final path = 'assets/images/${widget.characterType.spritePath}/Idle.png';
      final data = await rootBundle.load(path);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() => _image = frame.image);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
      );
    }

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final currentFrame =
            (_animController.value * widget.frameCount).floor() %
                widget.frameCount;

        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpriteFramePainter(
            image: _image!,
            frameIndex: currentFrame,
          ),
        );
      },
    );
  }
}

class _SpriteFramePainter extends CustomPainter {
  final ui.Image image;
  final int frameIndex;

  _SpriteFramePainter({required this.image, required this.frameIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final srcRect = Rect.fromLTWH(frameIndex * 128.0, 0, 128, 128);
    final dstRect = Offset.zero & size;
    final paint = Paint()..filterQuality = FilterQuality.none;
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _SpriteFramePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.frameIndex != frameIndex;
}
