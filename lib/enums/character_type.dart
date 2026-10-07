enum CharacterType {
  fireWizard('Fire_Wizard'),
  lightningWizard('Lightning_Mage'),
  knight1('Knight_1'),
  samurai('Samurai'),
  samuraiCommander('Samurai_Commander'),
  skeletonWarrior('Skeleton_Warrior');

  final String spritePath;
  const CharacterType(this.spritePath);
}
