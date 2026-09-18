enum CharacterState {
  idle('Idle.png'),
  walk('Walk.png'),
  run('Run.png'),
  jump('Jump.png'),
  attack1('Attack_1.png'),
  attack2('Attack_2.png'),
  attack3('Attack_3.png'),
  special('Special.png'),
  hurt('Hurt.png'),
  dead('Dead.png');

  final String spritePath;
  const CharacterState(this.spritePath);
}
