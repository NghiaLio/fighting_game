/// Quản lý tập trung toàn bộ chuỗi ký tự hiển thị (Strings) trong trò chơi
class AppStrings {
  AppStrings._();

  // ==========================================
  // 1. MÀN HÌNH CHÍNH (Home Screen & Settings)
  // ==========================================
  static const String settingsTitle = 'CÀI ĐẶT TRÒ CHƠI';
  static const String musicLabel = 'Nhạc nền:';
  static const String sfxLabel = 'Hiệu ứng:';
  static const String close = 'ĐÓNG';

  static const String warrior = 'CHIẾN BINH';
  static const String currencyAmount = '9,999';

  static const String campaignTitle = 'CHIẾN DỊCH';
  static const String currentStage = '• Màn hiện tại: MÀN 1 (Rừng Cổ Valdris)';
  static const String opponent = '• Đối thủ: Kỵ Sĩ Bóng Đêm';
  static const String matchMode = '• Chế độ: Tử chiến (Bo3)';
  static const String progressMaps = 'TIẾN TRÌNH: 0 / 7 MÀN';

  static const String battleNow = 'XUẤT TRẬN';
  static const String heroesRoster = 'ANH HÙNG';
  static const String settings = 'CÀI ĐẶT';

  // ==========================================
  // 2. MÀN HÌNH TẢI TRẬN (Home Loading Screen)
  // ==========================================
  static const String loadingInitGraphics =
      'Đang khởi tạo đồ họa & bản đồ...';
  static const String loadingArenaControls =
      'Đang tải đấu trường & nút điều khiển...';
  static const String loadingFireWizard =
      'Đang tải dữ liệu Pháp Sư Lửa...';
  static const String loadingPreparingArena =
      'Đang chuẩn bị đấu trường & đối thủ AI...';
  static const String loadingReady = 'Sẵn sàng! Hãy chuẩn bị chiến đấu!';
  static const String loadingTapToStart = 'CHẠM ĐỂ BẮT ĐẦU';

  // ==========================================
  // 3. MÀN HÌNH CHỌN TƯỚNG (Character Select Screen)
  // ==========================================
  static const String charSelectHome = 'TRANG CHỦ';
  static const String charSelectTitle = 'CHỌN ANH HÙNG';
  static const String charSelectMode = '1 VS 1';
  static const String charSelectRosterTitle = 'DANH SÁCH ANH HÙNG (12)';
  static const String statAttack = 'CÔNG';
  static const String statDefense = 'THỦ';
  static const String statSpeed = 'TỐC ĐỘ';
  static const String statRange = 'TẦM ĐÁNH';
  static const String ultimatePrefix = 'TUYỆT KỸ: ';
  static const String charSelectConfirm = 'XUẤT TRẬN!';

  // ==========================================
  // 4. MÀN HÌNH TRẬN ĐẤU & KẾT THÚC (Game Play & Game Over)
  // ==========================================
  static const String victory = 'CHIẾN THẮNG!';
  static const String defeat = 'THẤT BẠI!';
  static const String victorySubtitle =
      'Xuất sắc! Bạn đã đánh bại hoàn toàn đối thủ!';
  static const String defeatSubtitle =
      'Bạn đã gục ngã! Hãy đứng dậy và giành lại vinh quang!';
  static const String gamePlayHome = 'TRANG CHỦ';
  static const String replay = 'ĐẤU LẠI';
  static const String continuePrompt = 'TIẾP TỤC?';
  static const String continueAction = 'TIẾP TỤC';
  static const String exitAction = 'THOÁT';
  static const String giveUpAction = 'MENU CHÍNH';

  // ==========================================
  // 5. MENU TẠM DỪNG (Pause Menu & In-Game Settings)
  // ==========================================
  static const String pauseTitle = 'TẠM DỪNG';
  static const String pauseBgm = 'NHẠC NỀN';
  static const String pauseSfx = 'HIỆU ỨNG';
  static const String pauseResume = 'TIẾP TỤC';
  static const String pauseRestart = 'ĐẤU LẠI';
  static const String pauseQuit = 'MENU CHÍNH';

  // ==========================================
  // 6. BẢN ĐỒ CHIẾN DỊCH (Campaign Map)
  // ==========================================
  static const String mapTitle = 'BẢN ĐỒ CHIẾN DỊCH';
  static const String mapBookTitle = 'SÁCH CỔ';
  static const String mapBookContent = 'Tính năng Sách Cổ đang được phát triển!';
  static const String mapLeaderboardTitle = 'BẢNG XẾP HẠNG';
  static const String mapLeaderboardContent = 'Tổng số sao chiến dịch đã đạt: ';
  static const String mapSelect = 'XUẤT TRẬN';
  static const String mapClose = 'ĐÓNG';
  static const String mapObjective1 = '⭐ Giành chiến thắng';
  static const String mapObjective2 = '⭐⭐ Lượng máu trên 50%';
  static const String mapObjective3 = '⭐⭐⭐ Thắng trong 60 giây';
  
  static const String mapStagePrefix = 'ẢI';
  static const String mapOpponentPrefix = 'ĐỐI THỦ:';

  // Tên màn chơi, boss và mô tả (Đồng bộ với bản đồ và cốt truyện)
  static const String mapStage1Title = 'Rừng Cổ Valdris';
  static const String mapStage1Desc = 'Rừng sâu nguyên sinh ngàn năm, nơi khởi đầu hành trình phong ấn Hư Không.';
  static const String mapStage1Boss = 'Kỵ Sĩ Bóng Đêm';
  
  static const String mapStage2Title = 'Hẻm Núi Sa Mạc';
  static const String mapStage2Desc = 'Cao nguyên sa mạc hoàng hôn với những hẻm núi đá đỏ cheo leo.';
  static const String mapStage2Boss = 'Kiếm Khách Sa Mạc';
  
  static const String mapStage3Title = 'Vực Nham Thạch';
  static const String mapStage3Desc = 'Miệng núi lửa khổng lồ sục sôi những dòng dung nham đỏ rực nghìn độ.';
  static const String mapStage3Boss = 'Pháp Sư Lửa';

  static const String mapStage4Title = 'Thung Lũng Mây Ngàn';
  static const String mapStage4Desc = 'Vùng thánh địa bay lơ lửng giữa biển mây và những dòng thác nước cổ đại.';
  static const String mapStage4Boss = 'Pháp Sư Sấm Sét';

  static const String mapStage5Title = 'Đỉnh Núi Băng Tuyết';
  static const String mapStage5Desc = 'Đỉnh núi tuyết vĩnh cửu và lâu đài băng huyền bí ngưng đọng thời gian.';
  static const String mapStage5Boss = 'Hiệp Sĩ Băng';

  static const String mapStage6Title = 'Pháo Đài Bão Tím';
  static const String mapStage6Desc = 'Pháo đài núi lửa giữa cơn bão sấm sét tím cuồng nộ và bầu trời hắc ám.';
  static const String mapStage6Boss = 'Đại Tướng Samurai';

  static const String mapStage7Title = 'Đền Cổ Thác Mây';
  static const String mapStage7Desc = 'Đấu trường đền cổ nghìn năm giữa thác mây canh giữ cánh cổng Hư Không.';
  static const String mapStage7Boss = 'Chúa Tể Xương Molcharis';
}
