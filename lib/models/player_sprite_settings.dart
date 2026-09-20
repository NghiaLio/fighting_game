import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:flame/components.dart';

class PlayerSpriteSettings {
  final StateSpriteSetting attack1;
  final StateSpriteSetting attack2;
  final StateSpriteSetting attack3;
  final StateSpriteSetting dead;
  final StateSpriteSetting hurt;
  final StateSpriteSetting idle;
  final StateSpriteSetting jump;
  final StateSpriteSetting run;
  final StateSpriteSetting special;
  final StateSpriteSetting walk;

  PlayerSpriteSettings({
    required this.attack1,
    required this.attack2,
    required this.attack3,
    required this.dead,
    required this.hurt,
    required this.idle,
    required this.jump,
    required this.run,
    required this.special,
    required this.walk,
  });

  StateSpriteSetting getSettingsForState(CharacterState state) =>
      switch (state) {
        CharacterState.attack1 => attack1,
        CharacterState.attack2 => attack2,
        CharacterState.attack3 => attack3,
        CharacterState.dead => dead,
        CharacterState.hurt => hurt,
        CharacterState.idle => idle,
        CharacterState.jump => jump,
        CharacterState.run => run,
        CharacterState.special => special,
        CharacterState.walk => walk,
      };

  factory PlayerSpriteSettings.fromCharacterType(CharacterType characterType) =>
      switch (characterType) {
        CharacterType.fireWizard => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.12, Anchor.bottomCenter),
          attack2: StateSpriteSetting(0.12, Anchor.bottomCenter),
          attack3: StateSpriteSetting(0.09, Anchor.bottomCenter),
          dead: StateSpriteSetting(0.18, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.15, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.18, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.12, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.10, Anchor.bottomCenter),
          walk: StateSpriteSetting(0.14, Anchor.bottomCenter),
        ),
        CharacterType.lightningWizard => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomCenter),
          attack3: StateSpriteSetting(0.1, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.25, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.2, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomRight),
          jump: StateSpriteSetting(0.2, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomCenter),
        ),
        CharacterType.wandererMagician => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.1, Anchor.bottomCenter),
          dead: StateSpriteSetting(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.2, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomRight),
          jump: StateSpriteSetting(0.16, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomRight),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomCenter),
        ),
        CharacterType.skeletonWarrior => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.1, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.25, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.5, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.skeletonArcher => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomCenter),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.28, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.25, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.skeletonSpearman => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.2, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.25, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.3, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.knight1 => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.12, Anchor.bottomCenter),
          attack2: StateSpriteSetting(0.12, Anchor.bottomCenter),
          attack3: StateSpriteSetting(0.12, Anchor.bottomCenter),
          dead: StateSpriteSetting(0.18, Anchor.bottomCenter),
          hurt: StateSpriteSetting(0.15, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.20, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.12, Anchor.bottomCenter),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.12, Anchor.bottomCenter),
          walk: StateSpriteSetting(0.14, Anchor.bottomCenter),
        ),
        CharacterType.knight2 => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.25, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.2, Anchor.bottomLeft),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.knight3 => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.25, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.2, Anchor.bottomLeft),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samurai => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.25, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.18, Anchor.bottomLeft),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samuraiArcher => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.25, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.15, Anchor.bottomLeft),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
        CharacterType.samuraiCommander => PlayerSpriteSettings(
          attack1: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack2: StateSpriteSetting(0.2, Anchor.bottomLeft),
          attack3: StateSpriteSetting(0.25, Anchor.bottomLeft),
          dead: StateSpriteSetting(0.28, Anchor.bottomLeft),
          hurt: StateSpriteSetting(0.3, Anchor.bottomCenter),
          idle: StateSpriteSetting(0.3, Anchor.bottomCenter),
          jump: StateSpriteSetting(0.2, Anchor.bottomLeft),
          run: StateSpriteSetting(0.08, Anchor.bottomCenter),
          special: StateSpriteSetting(0.1, Anchor.bottomLeft),
          walk: StateSpriteSetting(0.18, Anchor.bottomLeft),
        ),
      };
}

class StateSpriteSetting {
  final double time;
  final Anchor anchor;

  StateSpriteSetting(this.time, this.anchor);
}
