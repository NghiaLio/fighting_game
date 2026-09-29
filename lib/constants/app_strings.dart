/// Quản lý tập trung toàn bộ chuỗi ký tự hiển thị (Strings) trong trò chơi
class AppStrings {
  AppStrings._();

  // ==========================================
  // 1. MÀN HÌNH CHÍNH (Home Screen & Settings)
  // ==========================================
  static const String settingsTitle = 'GAME SETTINGS';
  static const String musicLabel = 'Music:';
  static const String sfxLabel = 'Sound FX:';
  static const String close = 'CLOSE';

  static const String warrior = 'WARRIOR';
  static const String currencyAmount = '9,999';

  static const String campaignTitle = 'CAMPAIGN';
  static const String currentStage = '• Current Stage: MAP 1 (Greenwood)';
  static const String opponent = '• Opponent: Armored Knight';
  static const String matchMode = '• Mode: Best of 3 Deathmatch';
  static const String progressMaps = 'PROGRESS: 0 / 7 MAPS';

  static const String battleNow = 'BATTLE NOW';
  static const String heroesRoster = 'HEROES (12)';
  static const String settings = 'SETTINGS';

  // ==========================================
  // 2. MÀN HÌNH TẢI TRẬN (Home Loading Screen)
  // ==========================================
  static const String loadingInitGraphics =
      'Initializing graphics & tilesets...';
  static const String loadingArenaControls =
      'Loading arena & input controls...';
  static const String loadingFireWizard =
      'Loading Fire Wizard character data...';
  static const String loadingPreparingArena =
      'Preparing arena & AI opponents...';
  static const String loadingReady = 'Ready! Prepare for battle!';
  static const String loadingTapToStart = 'TAP TO START';

  // ==========================================
  // 3. MÀN HÌNH CHỌN TƯỚNG (Character Select Screen)
  // ==========================================
  static const String charSelectHome = 'HOME';
  static const String charSelectTitle = 'HERO SELECTION';
  static const String charSelectMode = '1 VS 1';
  static const String charSelectRosterTitle = 'ROYAL CHAMPIONS (12)';
  static const String statAttack = 'ATTACK';
  static const String statDefense = 'DEFENSE';
  static const String statSpeed = 'SPEED';
  static const String statRange = 'RANGE';
  static const String ultimatePrefix = 'ULTIMATE: ';
  static const String charSelectConfirm = 'FIGHT!';

  // ==========================================
  // 4. MÀN HÌNH TRẬN ĐẤU & KẾT THÚC (Game Play & Game Over)
  // ==========================================
  static const String victory = 'VICTORY!';
  static const String defeat = 'DEFEAT!';
  static const String victorySubtitle =
      'Magnificent! You completely defeated your opponent!';
  static const String defeatSubtitle =
      'You have fallen! Rise and reclaim your honor!';
  static const String gamePlayHome = 'HOME';
  static const String replay = 'REPLAY';
  static const String continuePrompt = 'CONTINUE?';
  static const String continueAction = 'CONTINUE';
  static const String exitAction = 'EXIT';
  static const String giveUpAction = 'MAIN MENU';

  // ==========================================
  // 5. MENU TẠM DỪNG (Pause Menu & In-Game Settings)
  // ==========================================
  static const String pauseTitle = 'PAUSED';
  static const String pauseBgm = 'MUSIC';
  static const String pauseSfx = 'SFX';
  static const String pauseResume = 'RESUME';
  static const String pauseRestart = 'RESTART';
  static const String pauseQuit = 'MAIN MENU';

  // ==========================================
  // 6. BẢN ĐỒ CHIẾN DỊCH (Campaign Map)
  // ==========================================
  static const String mapTitle = 'CAMPAIGN MAP';
  static const String mapBookTitle = 'CODEX';
  static const String mapBookContent = 'Codex feature is coming soon!';
  static const String mapLeaderboardTitle = 'LEADERBOARD';
  static const String mapLeaderboardContent = 'Total campaign stars earned: ';
  static const String mapSelect = 'SELECT';
  static const String mapClose = 'CLOSE';
  static const String mapObjective1 = '⭐ Achieve Victory';
  static const String mapObjective2 = '⭐⭐ Keep HP above 50%';
  static const String mapObjective3 = '⭐⭐⭐ Win within 60 seconds';
  
  static const String mapStagePrefix = 'STAGE';
  static const String mapOpponentPrefix = 'OPPONENT:';

  // Tên màn chơi, boss và mô tả
  static const String mapStage1Title = 'Ancient Forest';
  static const String mapStage1Desc = 'Dense primeval forest, home of the Goblin warriors.';
  static const String mapStage1Boss = 'Goblin Chieftain';
  
  static const String mapStage2Title = 'Desert Canyon';
  static const String mapStage2Desc = 'Barren land with harsh wind-swept cliffs.';
  static const String mapStage2Boss = 'Dual-Blade Swordsman';
  
  static const String mapStage3Title = 'Lava Abyss';
  static const String mapStage3Desc = 'Boiling lava rivers surging deep underground.';
  static const String mapStage3Boss = 'Fire Mage';

  static const String mapStage4Title = 'Twilight Valley';
  static const String mapStage4Desc = 'Valley bathed in twilight with ancient ruins.';
  static const String mapStage4Boss = 'Nomad Archer';

  static const String mapStage5Title = 'Ancient Snow Peak';
  static const String mapStage5Desc = 'Eternal snow-capped mountains with cruel winters.';
  static const String mapStage5Boss = 'Frost Knight';

  static const String mapStage6Title = 'Stormy Peak';
  static const String mapStage6Desc = 'Towering peaks constantly engulfed in relentless thunderstorms.';
  static const String mapStage6Boss = 'Thunder Mage';

  static const String mapStage7Title = 'Ruined Temple';
  static const String mapStage7Desc = 'Mysterious temple holding ancient evil powers.';
  static const String mapStage7Boss = 'Skeleton Warrior';
}
