class AiProfile {
  final double minThinkDelay;
  final double maxThinkDelay;
  final double blockChance;     // Tỉ lệ đỡ đòn (0.0 -> 1.0)
  final double comboChance;     // Tỉ lệ nối chuỗi chiêu khi trúng đích
  final double jumpChance;      // Tỉ lệ nhảy né chiêu / không chiến
  final double specialChance;   // Tỉ lệ dùng chiêu 3 và ULT
  final double runThreshold;    // Khoảng cách kích hoạt chạy bứt tốc
  final double hpMultiplier;    // Nhân máu đối thủ theo cấp map
  final double damageMultiplier;// Nhân sát thương theo cấp map

  const AiProfile({
    required this.minThinkDelay,
    required this.maxThinkDelay,
    required this.blockChance,
    required this.comboChance,
    required this.jumpChance,
    required this.specialChance,
    required this.runThreshold,
    required this.hpMultiplier,
    required this.damageMultiplier,
  });

  /// Tạo cấu hình AI leo thang mượt mà kết hợp cả Cấp Map (1..7) và Hiệp Đấu (1..3)
  /// - Map 1 được giảm độ khó rõ rệt để người chơi làm quen cơ chế và combo
  /// - Độ khó tăng từ tốn qua các màn sau, không tăng vọt đột ngột gây ức chế
  factory AiProfile.forMapAndRound(int mapLevel, int round) {
    // Chỉ số máu & sát thương: Map 1 ngang bằng player, tăng dần về Map 7
    const hpByMap = [1.00, 1.08, 1.18, 1.28, 1.40, 1.55, 1.70];
    const damageByMap = [1.00, 1.05, 1.12, 1.18, 1.25, 1.35, 1.45];

    final mapIdx = (mapLevel - 1).clamp(0, 6).toInt();
    final baseHp = hpByMap[mapIdx];
    final baseDmg = damageByMap[mapIdx];

    // Hệ số tiến trình theo map: 0.0 (Map 1) -> 1.0 (Map 7)
    final mapProgress = mapIdx / 6.0;

    switch (round) {
      case 1:
        // Hiệp 1: AI phản xạ vừa, biết tấn công chủ động
        return AiProfile(
          minThinkDelay: 0.75 - 0.40 * mapProgress,
          maxThinkDelay: 1.15 - 0.55 * mapProgress,
          blockChance: (0.05 + 0.30 * mapProgress).clamp(0.0, 0.35),
          comboChance: 0.15 + 0.30 * mapProgress,
          jumpChance: 0.08 + 0.15 * mapProgress,
          specialChance: 0.15 + 0.25 * mapProgress,
          runThreshold: 230 - 50 * mapProgress,
          hpMultiplier: baseHp,
          damageMultiplier: baseDmg,
        );

      case 2:
        // Hiệp 2: AI nhanh hơn, biết đỡ & nối combo
        return AiProfile(
          minThinkDelay: 0.55 - 0.30 * mapProgress,
          maxThinkDelay: 0.85 - 0.45 * mapProgress,
          blockChance: (0.15 + 0.35 * mapProgress).clamp(0.0, 0.50),
          comboChance: 0.25 + 0.35 * mapProgress,
          jumpChance: 0.15 + 0.20 * mapProgress,
          specialChance: 0.25 + 0.35 * mapProgress,
          runThreshold: 200 - 40 * mapProgress,
          hpMultiplier: baseHp * 1.03,
          damageMultiplier: baseDmg * 1.03,
        );

      default:
        // Hiệp 3: AI quyết liệt, phản xạ nhanh, block cao
        return AiProfile(
          minThinkDelay: 0.35 - 0.18 * mapProgress,
          maxThinkDelay: 0.65 - 0.30 * mapProgress,
          blockChance: (0.25 + 0.40 * mapProgress).clamp(0.0, 0.65),
          comboChance: 0.35 + 0.40 * mapProgress,
          jumpChance: 0.25 + 0.30 * mapProgress,
          specialChance: 0.35 + 0.45 * mapProgress,
          runThreshold: 170 - 35 * mapProgress,
          hpMultiplier: baseHp * 1.06,
          damageMultiplier: baseDmg * 1.06,
        );
    }
  }
}
