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
  });

  factory PlayerStats.fromPlayerType(CharacterType type) => switch (type) {
    CharacterType.fireWizard => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 5,
      attackResistance: 1,
      walkSpeed: 0.8,
      runSpeed: 3,
      jumpPower: 350,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 130, // Light dagger strike
      attack2Reach: 150, // Forward thrust
      attack3Reach: 250, // Long-range flamethrower sweep
      specialReach: 500, // Ranged fireball projectile
    ),
    CharacterType.lightningWizard => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.9,
      runSpeed: 3.5,
      jumpPower: 260,
      jumpDistance: 150,
      powerUpDuration: 10,
      attack1Reach: 135,
      attack2Reach: 160,
      attack3Reach: 240,
      specialReach: 480,
    ),
    CharacterType.wandererMagician => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 0,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.7,
      runSpeed: 4.5,
      jumpPower: 350,
      jumpDistance: 190,
      powerUpDuration: 10,
      attack1Reach: 130,
      attack2Reach: 150,
      attack3Reach: 200,
      specialReach: 450,
    ),
    CharacterType.skeletonArcher => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.6,
      runSpeed: 5,
      jumpPower: 100,
      jumpDistance: 100,
      powerUpDuration: 10,
      attack1Reach: 160,
      attack2Reach: 260,
      attack3Reach: 360,
      specialReach: 550,
    ),
    CharacterType.skeletonSpearman => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.7,
      runSpeed: 3,
      jumpPower: 100,
      jumpDistance: 100,
      powerUpDuration: 10,
      attack1Reach: 160,
      attack2Reach: 180,
      attack3Reach: 220,
      specialReach: 260,
    ),
    CharacterType.skeletonWarrior => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.8,
      runSpeed: 3.5,
      jumpPower: 100,
      jumpDistance: 100,
      powerUpDuration: 10,
      attack1Reach: 130,
      attack2Reach: 150,
      attack3Reach: 180,
      specialReach: 200,
    ),
    CharacterType.samurai => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.8,
      runSpeed: 3.5,
      jumpPower: 450,
      jumpDistance: 220,
      powerUpDuration: 10,
      attack1Reach: 140,
      attack2Reach: 165,
      attack3Reach: 220,
      specialReach: 240,
    ),
    CharacterType.samuraiArcher => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.7,
      runSpeed: 3.5,
      jumpPower: 300,
      jumpDistance: 150,
      powerUpDuration: 10,
      attack1Reach: 150,
      attack2Reach: 240,
      attack3Reach: 320,
      specialReach: 520,
    ),
    CharacterType.samuraiCommander => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.8,
      runSpeed: 3.5,
      jumpPower: 450,
      jumpDistance: 250,
      powerUpDuration: 10,
      attack1Reach: 145,
      attack2Reach: 170,
      attack3Reach: 230,
      specialReach: 260,
    ),
    CharacterType.knight1 => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 1.2,
      runSpeed: 4.5,
      jumpPower: 400,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 135, // Diagonal slash
      attack2Reach: 155, // Horizontal thrust
      attack3Reach: 195, // Heavy 360 spin slash
      specialReach: 180, // Shield bash / counter
    ),
    CharacterType.knight2 => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 1.2,
      runSpeed: 5,
      jumpPower: 400,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 135,
      attack2Reach: 155,
      attack3Reach: 195,
      specialReach: 180,
    ),
    CharacterType.knight3 => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 3,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 1.2,
      runSpeed: 5,
      jumpPower: 400,
      jumpDistance: 200,
      powerUpDuration: 10,
      attack1Reach: 135,
      attack2Reach: 155,
      attack3Reach: 195,
      specialReach: 180,
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
