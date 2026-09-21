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
  static const String loadingInitGraphics = 'Initializing graphics & tilesets...';
  static const String loadingArenaControls = 'Loading arena & input controls...';
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
  static const String charSelectMode = '1 VS 1 DEATHMATCH';
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

  // ==========================================
  // 5. MENU TẠM DỪNG (Pause Menu & In-Game Settings)
  // ==========================================
  static const String pauseTitle = 'PAUSED';
  static const String pauseBgm = 'MUSIC';
  static const String pauseSfx = 'SFX';
  static const String pauseResume = 'RESUME';
  static const String pauseRestart = 'RESTART';
  static const String pauseQuit = 'MAIN MENU';
}
