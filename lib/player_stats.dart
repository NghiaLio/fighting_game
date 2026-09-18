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
  });

  factory PlayerStats.fromPlayerType(CharacterType type) => switch (type) {
    CharacterType.fireWizard => PlayerStats(
      attack1Power: 2,
      attack2Power: 2,
      attack3Power: 2,
      specialAttackPower: 4,
      attackResistance: 1,
      walkSpeed: 0.8,
      runSpeed: 3,
      jumpPower: 350,
      jumpDistance: 200,
      powerUpDuration: 10,
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
    ),
  };

  double getAttackPower(CharacterState state) => switch (state) {
    CharacterState.attack1 => attack1Power,
    CharacterState.attack2 => attack2Power,
    CharacterState.attack3 => attack3Power,
    CharacterState.special => specialAttackPower,
    _ => 0,
  };
}
