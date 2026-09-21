/// Quản lý tập trung toàn bộ đường dẫn Assets (Hình ảnh, Âm thanh, Sprite) của trò chơi
class AppAssets {
  AppAssets._();

  // ==========================================
  // 1. GIAO DIỆN FLUTTER (Flutter UI Assets)
  // ==========================================
  static const String bgHome = 'assets/images/Bg_homes/bg_home.png';
  static const String gameLogo = 'assets/images/Bg_homes/logo.png';
  static const String uiTileset = 'assets/images/Bg_homes/ui_tileset.png';
  static const String uiTileset2 = 'assets/images/Bg_homes/UI_tileset_2.png';
  static const String selectPer = 'assets/images/Bg_homes/select_per.png';
  static const String boardSettings = 'assets/images/Bg_homes/board_settings.png';
  static const String otherButton = 'assets/images/Bg_homes/other_button.png';
  static const String resumeButton = 'assets/images/Bg_homes/resume.png';
  static const String volumeIcon = 'assets/images/Bg_homes/volume.png';
  static const String settingButton = 'assets/images/Buttons/setting.png';
  static const String imgWin = 'assets/images/sfx/win.png';
  static const String imgLose = 'assets/images/sfx/lose.png';
  // Round announcement images (Flutter asset path)
  static const String imgRound1Flutter = 'assets/images/sfx/round1.png';
  static const String imgRound2Flutter = 'assets/images/sfx/round2.png';
  static const String imgRound3Flutter = 'assets/images/sfx/round3.png';

  // ==========================================
  // 2. TÀI NGUYÊN FLAME ENGINE (Flame Image Assets)
  // ==========================================
  // Phông nền đấu trường (Arena Backgrounds)
  static const String arenaBg1 = 'Backgrounds/bg1.png';
  static const String arenaBg2 = 'Backgrounds/bg2.png';
  static const String arenaBg3 = 'Backgrounds/bg3.png';
  static const String arenaBg4 = 'Backgrounds/bg4.png';
  static const String arenaBg5 = 'Backgrounds/bg5.png';
  static const String arenaBg6 = 'Backgrounds/bg6.png';
  static const String arenaBg7 = 'Backgrounds/bg7.png';

  // Hiệu ứng hình ảnh (VFX & HUD)
  static const String hitSpark = 'sfx/hit_spark.png';
  static const String dustPuff = 'sfx/dust_puff.png';
  static const String fireballProjectile = 'Fire_Wizard/Projectile1.png';
  static const String round1 = 'sfx/round1.png';
  static const String round2 = 'sfx/round2.png';
  static const String round3 = 'sfx/round3.png';
  static const String vfxWin = 'sfx/win.png';
  static const String vfxLose = 'sfx/lose.png';

  // Nút điều khiển chiến đấu (Battle Control Buttons)
  static const String btnLeft = 'Buttons/left.png';
  static const String btnRight = 'Buttons/right.png';
  static const String btnUp = 'Buttons/up.png';
  static const String btnAttack = 'Buttons/attack.png';
  static const String btnSpecial = 'Buttons/special.png';
  static const String btnSprint = 'Buttons/sprint.png';

  /// Danh sách tất cả nút điều khiển để nạp trước (preload)
  static const List<String> battleControls = [
    btnLeft,
    btnRight,
    btnUp,
    btnAttack,
    btnSpecial,
    btnSprint,
  ];

  // ==========================================
  // 3. ÂM THANH SFX & BGM (Audio Assets)
  // ==========================================
  static const String sfxButton = 'button.wav';
  static const String sfxAttack1 = 'attack_1.mp3';
  static const String sfxAttack2 = 'attac_2.mp3';
  static const String sfxFireWhoosh = 'sfx_fire_whoosh.mp3';
  static const String sfxFireSpark = 'sfx_fire_spark.wav';
  static const String sfxFireballLaunch = 'sfx_fireball_launch_[cut_2sec].wav';
  static const String sfxWin = 'win.mp3';
  static const String sfxLose = 'lose.mp3';
  static const String sfxRound1 = 'round_1.wav';
  static const String sfxRound2 = 'round_2.wav';
  static const String sfxRound3 = 'round_3.wav';
  static const String sfxPunch = 'soraatwod-punch-416719.mp3';
  static const String fight = 'fight.wav';

  /// Danh sách tất cả âm thanh cần nạp trước vào bộ nhớ (preload)
  static const List<String> allAudio = [
    sfxButton,
    sfxAttack1,
    sfxAttack2,
    sfxFireWhoosh,
    sfxFireSpark,
    sfxFireballLaunch,
    sfxWin,
    sfxLose,
    sfxRound1,
    sfxRound2,
    sfxRound3,
    fight,
    sfxPunch,
  ];

  // ==========================================
  // 4. TIỆN ÍCH ĐƯỜNG DẪN SPRITE NHÂN VẬT
  // ==========================================
  /// Tạo đường dẫn ảnh Idle tĩnh cho UI Flutter
  static String characterIdleFlutterPath(String spriteFolder) =>
      'assets/images/$spriteFolder/Idle.png';

  /// Tạo đường dẫn Sprite cho Flame Engine
  static String characterStateFlamePath(String spriteFolder, String stateFile) =>
      '$spriteFolder/$stateFile';
}
