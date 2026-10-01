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

  /// Tạo cấu hình AI leo thang kết hợp giữa Map (1..7) và Round (1..3)
  factory AiProfile.forMapAndRound(int mapLevel, int round) {
    const hpByMap = [1.0, 1.15, 1.30, 1.50, 1.75, 2.0, 2.5];
    const damageByMap = [1.0, 1.10, 1.20, 1.30, 1.40, 1.55, 1.75];
    final mapIndex = (mapLevel - 1).clamp(0, 6).toInt();
    final mapHp = hpByMap[mapIndex];
    final mapDamage = damageByMap[mapIndex];

    return switch (round) {
      1 => AiProfile(
        minThinkDelay: 1.0,
        maxThinkDelay: 1.4,
        blockChance: 0,
        comboChance: 0,
        jumpChance: 0.05,
        specialChance: 0.10,
        runThreshold: 240,
        hpMultiplier: mapHp,
        damageMultiplier: mapDamage,
      ),
      2 => AiProfile(
        minThinkDelay: 0.5,
        maxThinkDelay: 0.75,
        blockChance: 0.35,
        comboChance: 0.45,
        jumpChance: 0.25,
        specialChance: 0.40,
        runThreshold: 190,
        hpMultiplier: mapHp * 1.05,
        damageMultiplier: mapDamage * 1.05,
      ),
      _ => AiProfile(
        minThinkDelay: 0.15,
        maxThinkDelay: 0.30,
        blockChance: 0.75,
        comboChance: 0.85,
        jumpChance: 0.55,
        specialChance: 0.80,
        runThreshold: 150,
        hpMultiplier: mapHp * 1.15,
        damageMultiplier: mapDamage * 1.15,
      ),
    };
  }
}
