import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';

class PlayerStats {
  final double attack1Power;
  final double attack2Power;
  final double attack3Power;
  final double specialAttackPower;
  final double attackResistance;
  final double walkSpeed;
  final double runSpeed;
  final double jumpPower;
  final double jumpDistance;
  final double powerUpDuration;

  // Custom attack reaches for each character archetype
  final double attack1Reach;
  final double attack2Reach;
  final double attack3Reach;
  final double specialReach;
  final double healthMultiplier;

  PlayerStats({
    required this.attack1Power,
    required this.attack2Power,
    required this.attack3Power,
    required this.specialAttackPower,
    required this.attackResistance,
    required this.walkSpeed,
    required this.runSpeed,
    required this.jumpPower,
    required this.jumpDistance,
    required this.powerUpDuration,
    this.attack1Reach = 135.0,
    this.attack2Reach = 155.0,
    this.attack3Reach = 210.0,
    this.specialReach = 260.0,
    this.healthMultiplier = 1.0,
  });

  /// Chỉ số cân bằng toàn diện:
  /// - Máu (healthMultiplier) dao động trong khoảng hợp lý 0.94 -> 1.12 (không còn chênh lệch cực đoan 0.80 -> 1.30)
  /// - Giáp (attackResistance) dao động 0.96 -> 1.08
  /// - Sát thương các đòn được điều chỉnh tương xứng với tầm đánh và phong cách chiến đấu
  factory PlayerStats.fromPlayerType(CharacterType type) => switch (type) {
    // 1. Fire Wizard (Pháp sư lửa): Tầm xa, đòn phép diện rộng, máu và thủ được nâng lên mức ổn định
    CharacterType.fireWizard => PlayerStats(
      attack1Power: 2.2,
      attack2Power: 2.6,
      attack3Power: 3.8,
      specialAttackPower: 5.2,
      attackResistance: 0.96,
      healthMultiplier: 0.94,
      walkSpeed: 0.82,
      runSpeed: 3.2,
      jumpPower: 360,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 135,
      attack2Reach: 155,
      attack3Reach: 250, // Càn quét lửa tầm xa
      specialReach: 500, // Cầu lửa bay toàn màn hình
    ),

    // 2. Lightning Wizard (Pháp sư sét): Linh hoạt, nhảy cao, sốc sát thương sấm sét
    CharacterType.lightningWizard => PlayerStats(
      attack1Power: 2.2,
      attack2Power: 2.7,
      attack3Power: 3.9,
      specialAttackPower: 5.2,
      attackResistance: 0.98,
      healthMultiplier: 0.96,
      walkSpeed: 0.90,
      runSpeed: 3.5,
      jumpPower: 380, // Nâng từ 260 lên 380 để không bị thọt nhảy
      jumpDistance: 180,
      powerUpDuration: 10,
      attack1Reach: 138,
      attack2Reach: 165,
      attack3Reach: 245,
      specialReach: 480,
    ),

    // 3. Skeleton Warrior (Chiến binh xương): Đòn chém uy lực, sửa lỗi nhảy 100 thành 380
    CharacterType.skeletonWarrior => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.8,
      attack3Power: 4.0,
      specialAttackPower: 5.0,
      attackResistance: 1.05,
      healthMultiplier: 1.08,
      walkSpeed: 0.82,
      runSpeed: 3.4,
      jumpPower: 380, // Sửa từ 100 lên 380 để nhảy linh hoạt bình thường
      jumpDistance: 180,
      powerUpDuration: 10,
      attack1Reach: 135,
      attack2Reach: 160,
      attack3Reach: 200,
      specialReach: 230,
    ),

    // 4. Samurai Archer (Xạ thủ Samurai): Cung thuật biến hóa, tên ma pháp tầm xa
    CharacterType.samurai => PlayerStats(
      attack1Power: 2.2,
      attack2Power: 2.8,
      attack3Power: 4.0,
      specialAttackPower: 5.2,
      attackResistance: 1.00,
      healthMultiplier: 1.00,
      walkSpeed: 0.85,
      runSpeed: 3.5,
      jumpPower: 440,
      jumpDistance: 220,
      powerUpDuration: 10,
      attack1Reach: 140,
      attack2Reach: 175,
      attack3Reach: 245,
      specialReach: 520, // Bắn đại tiễn ma thuật xuyên màn hình
    ),

    // 5. Samurai Commander (Đại tướng Samurai): Uy lực mạnh mẽ, phong thái thủ lĩnh
    CharacterType.samuraiCommander => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.9,
      attack3Power: 4.1,
      specialAttackPower: 5.4,
      attackResistance: 1.02,
      healthMultiplier: 1.04,
      walkSpeed: 0.85,
      runSpeed: 3.5,
      jumpPower: 440,
      jumpDistance: 240,
      powerUpDuration: 10,
      attack1Reach: 145,
      attack2Reach: 172,
      attack3Reach: 232,
      specialReach: 265,
    ),

    // 6. Knight (Kỵ sĩ): Bền bỉ, giáp chắc nhưng không còn quá trâu bò làm mất cân bằng
    CharacterType.knight1 => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.7,
      attack3Power: 3.8,
      specialAttackPower: 5.0,
      attackResistance: 1.08, // Giảm từ 1.25 xuống 1.08
      healthMultiplier: 1.12, // Giảm từ 1.30 xuống 1.12
      walkSpeed: 0.78,
      runSpeed: 3.0,
      jumpPower: 400,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 138,
      attack2Reach: 160,
      attack3Reach: 200,
      specialReach: 210,
    ),

    // 7. Son Goku: Bậc thầy võ thuật, đòn thế biến hóa, được cân bằng hài hòa
    CharacterType.sonGoku => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.8,
      attack3Power: 3.9,
      specialAttackPower: 5.5,
      attackResistance: 1.02,
      healthMultiplier: 1.06,
      walkSpeed: 0.92,
      runSpeed: 3.6,
      jumpPower: 390,
      jumpDistance: 220,
      powerUpDuration: 11,
      attack1Reach: 142,
      attack2Reach: 172,
      attack3Reach: 280,
      specialReach: 500, // Kamehameha Siêu Cấp
    ),

    // 8. Wanderer Magician (Pháp Sư Lãng Khách): Khống chế tầm xa, cầu ma thuật ảo ảnh
    CharacterType.wandererMagician => PlayerStats(
      attack1Power: 2.2,
      attack2Power: 2.6,
      attack3Power: 3.8,
      specialAttackPower: 5.2,
      attackResistance: 0.98,
      healthMultiplier: 1.0,
      walkSpeed: 0.88,
      runSpeed: 3.4,
      jumpPower: 390,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 140,
      attack2Reach: 165,
      attack3Reach: 230,
      specialReach: 500, // Cầu Ma Thuật tầm xa
    ),
  };

  double getAttackPower(CharacterState state) => switch (state) {
    CharacterState.attack1 => attack1Power,
    CharacterState.attack2 => attack2Power,
    CharacterState.attack3 => attack3Power,
    CharacterState.special => specialAttackPower,
    _ => 0,
  };

  double getAttackReach(CharacterState state) => switch (state) {
    CharacterState.attack1 => attack1Reach,
    CharacterState.attack2 => attack2Reach,
    CharacterState.attack3 => attack3Reach,
    CharacterState.special => specialReach,
    _ => 120.0,
  };
}
