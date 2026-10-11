enum CharacterType {
  fireWizard('Fire_Wizard'),
  lightningWizard('Lightning_Mage'),
  knight1('Knight_1'),
  samurai('Samurai_Archer'),
  samuraiCommander('Samurai_Commander'),
  skeletonWarrior('Skeleton_Warrior'),
  sonGoku('Son_Goku'),
  wandererMagician('Wanderer_Magican');

  final String spritePath;
  const CharacterType(this.spritePath);

  String get displayName => switch (this) {
    CharacterType.fireWizard => 'Pháp Sư Lửa',
    CharacterType.lightningWizard => 'Pháp Sư Sấm Sét',
    CharacterType.knight1 => 'Kỵ Sĩ Hoàng Gia',
    CharacterType.samurai => 'Xạ Thủ Samurai',
    CharacterType.samuraiCommander => 'Đại Tướng Samurai',
    CharacterType.skeletonWarrior => 'Chiến Binh Xương',
    CharacterType.sonGoku => 'Son Goku',
    CharacterType.wandererMagician => 'Pháp Sư Lãng Khách',
  };
}
