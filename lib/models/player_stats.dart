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
    this.attack1Reach = 78.0,
    this.attack2Reach = 92.0,
    this.attack3Reach = 120.0,
    this.specialReach = 145.0,
    this.healthMultiplier = 1.0,
  });

  /// Chỉ số cân bằng toàn diện:
  /// - Máu (healthMultiplier) dao động trong khoảng hợp lý 0.94 -> 1.12
  /// - Giáp (attackResistance) dao động 0.96 -> 1.08
  /// - Tầm đánh (attackReach) chuẩn hóa theo kích thước cơ thể 50px của sprite:
  ///   + Attack 1 (đấm/chém nhanh): 75 - 82px (khoảng cách chạm mặt)
  ///   + Attack 2 (chém lướt): 88 - 98px
  ///   + Attack 3 (đòn càn quét): 115 - 130px
  ///   + Special cận chiến: 135 - 150px; Special phóng đạn: 500 - 520px
  factory PlayerStats.fromPlayerType(CharacterType type) => switch (type) {
    // 1. Fire Wizard (Pháp sư lửa): Tầm xa, đòn phép diện rộng
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
      attack1Reach: 75,
      attack2Reach: 90,
      attack3Reach: 120,
      specialReach: 500, // Cầu lửa bay toàn màn hình (xử lý qua FireballComponent)
    ),

    // 2. Lightning Wizard (Pháp sư sét): Linh hoạt, sốc sát thương sấm sét cận chiến
    CharacterType.lightningWizard => PlayerStats(
      attack1Power: 2.2,
      attack2Power: 2.7,
      attack3Power: 3.9,
      specialAttackPower: 5.2,
      attackResistance: 0.98,
      healthMultiplier: 0.96,
      walkSpeed: 0.90,
      runSpeed: 3.5,
      jumpPower: 380,
      jumpDistance: 180,
      powerUpDuration: 10,
      attack1Reach: 78,
      attack2Reach: 92,
      attack3Reach: 125,
      specialReach: 145, // Chưởng sét cự ly cận chiến uy lực
    ),

    // 3. Skeleton Warrior (Chiến binh xương): Đòn chém uy lực, giáp cứng
    CharacterType.skeletonWarrior => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.8,
      attack3Power: 4.0,
      specialAttackPower: 5.0,
      attackResistance: 1.05,
      healthMultiplier: 1.08,
      walkSpeed: 0.82,
      runSpeed: 3.4,
      jumpPower: 380,
      jumpDistance: 180,
      powerUpDuration: 10,
      attack1Reach: 76,
      attack2Reach: 90,
      attack3Reach: 118,
      specialReach: 138,
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
      attack1Reach: 80,
      attack2Reach: 95,
      attack3Reach: 122,
      specialReach: 520, // Bắn đại tiễn ma thuật xuyên màn hình (xử lý qua ArrowComponent)
    ),

    // 5. Samurai Commander (Đại tướng Samurai): Uy lực mạnh mẽ, kiếm thuật bậc thầy
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
      attack1Reach: 82,
      attack2Reach: 98,
      attack3Reach: 130,
      specialReach: 150, // Trảm phong đại kiếm cận chiến
    ),

    // 6. Knight (Kỵ sĩ): Bền bỉ, giáp chắc, cự ly cân bằng
    CharacterType.knight1 => PlayerStats(
      attack1Power: 2.3,
      attack2Power: 2.7,
      attack3Power: 3.8,
      specialAttackPower: 5.0,
      attackResistance: 1.08,
      healthMultiplier: 1.12,
      walkSpeed: 0.78,
      runSpeed: 3.0,
      jumpPower: 400,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 78,
      attack2Reach: 92,
      attack3Reach: 120,
      specialReach: 140,
    ),

    // 7. Son Goku: Bậc thầy võ thuật, quyền cước biến hóa
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
      attack1Reach: 80,
      attack2Reach: 96,
      attack3Reach: 128,
      specialReach: 152, // Đòn dồn lực Kamehameha cự ly cận chiến
    ),

    // 8. Wanderer Magician (Pháp Sư Lãng Khách): Khống chế tầm xa, cầu ma thuật
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
      attack1Reach: 75,
      attack2Reach: 90,
      attack3Reach: 120,
      specialReach: 500, // Cầu Ma Thuật tầm xa (xử lý qua MagicOrbComponent)
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
