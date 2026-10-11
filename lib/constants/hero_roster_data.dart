import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/models/hero_info.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// 12 playable champions organized into 2 rows:
/// Row 1: Mages & Knights
/// Row 2: Samurais & Skeletons
const List<HeroInfo> kHeroRoster = [
  // --- DÒNG 1: PHÁP SƯ & HIỆP SĨ ---
  HeroInfo(
    type: CharacterType.fireWizard,
    name: 'PHÁP SƯ LỬA',
    title: 'Hỏa Long Tôn Giả (Ignis)',
    role: 'Pháp Sư - Hỏa Lực',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeCrown,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFF5722),
    atkRating: 0.95,
    defRating: 0.50,
    spdRating: 0.70,
    rngRating: 0.95,
    ultimateName: 'Hỏa Long Bộc Phá',
    description:
        'Tập trung ngọn lửa nguyên sơ thiêu rụi mọi phòng thủ. Cầu lửa có tầm bắn bao phủ toàn bộ đấu trường.',
    idleFrames: 7,
  ),
  HeroInfo(
    type: CharacterType.lightningWizard,
    name: 'PHÁP SƯ SẤM SÉT',
    title: 'Lôi Đình Tiên Phong (Voltis)',
    role: 'Pháp Sư - Khống Chế',
    pillarTile: SelectPerTile.pillarBlue,
    badgeTile: SelectPerTile.badgeCrown,
    gemTile: SelectPerTile.gemSapphire,
    primaryColor: Color(0xFF00E5FF),
    atkRating: 0.90,
    defRating: 0.55,
    spdRating: 0.85,
    rngRating: 0.88,
    ultimateName: 'Thiên Lôi Giáng Thế',
    description:
        'Tấn công với tốc độ ánh sáng, phóng điện gây tê liệt và áp chế kẻ thù trong chớp mắt.',
    idleFrames: 7,
    unlockLevel: 1,
    unlockPrice: 500,
  ),

  HeroInfo(
    type: CharacterType.knight1,
    name: 'KỴ SĨ HOÀNG GIA',
    title: 'Hiệp Sĩ Ánh Sáng (Arthur)',
    role: 'Đỡ Đòn - Hộ Vệ',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeShield,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFFD54F),
    atkRating: 0.80,
    defRating: 0.92,
    spdRating: 0.65,
    rngRating: 0.60,
    ultimateName: 'Phán Quyết Excalibur',
    description:
        'Bộ giáp sắt kiên cố cùng khiên thần thánh. Gây sát thương phản đòn cực lớn khi va chạm.',
    idleFrames: 4,
    unlockLevel: 2,
    unlockPrice: 1200,
  ),

  // --- DÒNG 2: SAMURAI & CHIẾN BINH XƯƠNG ---
  HeroInfo(
    type: CharacterType.samurai,
    name: 'KIẾM KHÁCH SAMURAI',
    title: 'Cuồng Phong Kiếm Tôn (Kenji)',
    role: 'Sát Thủ - Bão Kiếm',
    pillarTile: SelectPerTile.pillarRed,
    badgeTile: SelectPerTile.badgeSwords,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFFFF1744),
    atkRating: 0.96,
    defRating: 0.58,
    spdRating: 0.95,
    rngRating: 0.70,
    ultimateName: 'Vô Cực Trảm',
    description:
        'Đường kiếm Iaido siêu phàm với tốc độ xé gió. Chuỗi combo chém liên hoàn hủy diệt mục tiêu.',
    idleFrames: 6,
    unlockLevel: 2,
    unlockPrice: 2200,
  ),

  HeroInfo(
    type: CharacterType.samuraiCommander,
    name: 'ĐẠI TƯỚNG SAMURAI',
    title: 'Thống Lĩnh Bá Đạo (Nobunaga)',
    role: 'Đấu Sĩ - Thống Lĩnh',
    pillarTile: SelectPerTile.pillarBlue,
    badgeTile: SelectPerTile.badgeSwords,
    gemTile: SelectPerTile.gemSapphire,
    primaryColor: Color(0xFF1E88E5),
    atkRating: 0.90,
    defRating: 0.78,
    spdRating: 0.80,
    rngRating: 0.72,
    ultimateName: 'Bá Vương Trảm',
    description:
        'Đại tướng quân chiến trường sở hữu những nhát chém chấn động mặt đất, áp đảo toàn bộ cục diện.',
    idleFrames: 5,
    unlockLevel: 3,
    unlockPrice: 2800,
  ),
  HeroInfo(
    type: CharacterType.skeletonWarrior,
    name: 'CHIẾN BINH XƯƠNG',
    title: 'Tàn Tích Bất Tử (Krag)',
    role: 'Đấu Sĩ - Bất Tử',
    pillarTile: SelectPerTile.pillarPurple,
    badgeTile: SelectPerTile.badgeSkull,
    gemTile: SelectPerTile.gemRuby,
    primaryColor: Color(0xFF9C27B0),
    atkRating: 0.82,
    defRating: 0.75,
    spdRating: 0.75,
    rngRating: 0.65,
    ultimateName: 'Oán Hồn Bộc Phát',
    description:
        'Chiến binh cõi âm không biết đau đớn, kiên cường dồn ép đối thủ bằng những nhát đao nặng trịch.',
    idleFrames: 7,
    unlockLevel: 3,
    unlockPrice: 3000,
  ),
];
