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
    // Chỉ số máu & sát thương leo thang nhẹ nhàng (Map 1 nhẹ nhàng: HP 82%, Dmg 75%)
    const hpByMap = [0.82, 0.92, 1.00, 1.10, 1.22, 1.35, 1.50];
    const damageByMap = [0.75, 0.85, 0.95, 1.05, 1.15, 1.25, 1.40];

    final mapIdx = (mapLevel - 1).clamp(0, 6).toInt();
    final baseHp = hpByMap[mapIdx];
    final baseDmg = damageByMap[mapIdx];

    // Hệ số tiến trình theo map: 0.0 (Map 1) -> 1.0 (Map 7)
    final mapProgress = mapIdx / 6.0;

    switch (round) {
      case 1:
        // Hiệp 1: AI di chuyển thăm dò, phản xạ chậm, không đỡ đòn ở map đầu
        return AiProfile(
          minThinkDelay: 0.90 - 0.50 * mapProgress, // Map 1: 0.90s -> Map 7: 0.40s
          maxThinkDelay: 1.35 - 0.65 * mapProgress, // Map 1: 1.35s -> Map 7: 0.70s
          blockChance: (0.00 + 0.25 * mapProgress).clamp(0.0, 0.30), // Map 1: 0% -> Map 7: 25%
          comboChance: 0.08 + 0.25 * mapProgress,   // Map 1: 8% -> Map 7: 33%
          jumpChance: 0.04 + 0.12 * mapProgress,
          specialChance: 0.08 + 0.20 * mapProgress,
          runThreshold: 240 - 50 * mapProgress,
          hpMultiplier: baseHp,
          damageMultiplier: baseDmg,
        );

      case 2:
        // Hiệp 2: AI bắt đầu tăng tốc độ, biết đỡ đòn cơ bản nhưng có kẽ hở
        return AiProfile(
          minThinkDelay: 0.70 - 0.40 * mapProgress, // Map 1: 0.70s -> Map 7: 0.30s
          maxThinkDelay: 1.05 - 0.55 * mapProgress, // Map 1: 1.05s -> Map 7: 0.50s
          blockChance: (0.10 + 0.30 * mapProgress).clamp(0.0, 0.42), // Map 1: 10% -> Map 7: 40%
          comboChance: 0.18 + 0.30 * mapProgress,   // Map 1: 18% -> Map 7: 48%
          jumpChance: 0.12 + 0.18 * mapProgress,
          specialChance: 0.18 + 0.32 * mapProgress,
          runThreshold: 210 - 40 * mapProgress,
          hpMultiplier: baseHp * 1.03,
          damageMultiplier: baseDmg * 1.03,
        );

      default:
        // Hiệp 3 (Quyết định): AI quyết tâm hơn, nhưng vẫn công bằng (block tối đa 50%)
        return AiProfile(
          minThinkDelay: 0.50 - 0.26 * mapProgress, // Map 1: 0.50s -> Map 7: 0.24s
          maxThinkDelay: 0.85 - 0.42 * mapProgress, // Map 1: 0.85s -> Map 7: 0.43s
          blockChance: (0.18 + 0.32 * mapProgress).clamp(0.0, 0.50), // Map 1: 18% -> Map 7: 50%
          comboChance: 0.28 + 0.32 * mapProgress,   // Map 1: 28% -> Map 7: 60%
          jumpChance: 0.20 + 0.25 * mapProgress,
          specialChance: 0.28 + 0.40 * mapProgress,
          runThreshold: 180 - 40 * mapProgress,
          hpMultiplier: baseHp * 1.06,
          damageMultiplier: baseDmg * 1.06,
        );
    }
  }
}
