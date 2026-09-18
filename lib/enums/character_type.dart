enum CharacterType {
  fireWizard('Fire_Wizard'),
  lightningWizard('Lightning_Mage'),
  wandererMagician('Wanderer_Magican'),
  skeletonWarrior('Skeleton_Warrior'),
  skeletonArcher('Skeleton_Archer'),
  skeletonSpearman('Skeleton_Spearman'),
  samurai('Samurai'),
  samuraiArcher('Samurai_Archer'),
  samuraiCommander('Samurai_Commander'),
  knight1('Knight_1'),
  knight2('Knight_2'),
  knight3('Knight_3');

  final String spritePath;
  const CharacterType(this.spritePath);
}
