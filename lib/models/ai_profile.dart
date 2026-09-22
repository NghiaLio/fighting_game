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
    // 1. Hệ số nền tảng của từng Map (1..7)
    final mapIndex = (mapLevel - 1).clamp(0, 6);
    final baseHpMult = 1.0 + (mapIndex * 0.25);       // Map 1: 1.0x -> Map 7: 2.5x HP
    final baseDmgMult = 1.0 + (mapIndex * 0.125);     // Map 1: 1.0x -> Map 7: 1.75x Dmg
    final mapSpeedBoost = mapIndex * 0.08;             // Càng map sau phản xạ càng nhanh

    // 2. Hệ số leo thang qua 3 Round trong Map đó
    return switch (round) {
      1 => AiProfile(
        minThinkDelay: (1.2 - mapSpeedBoost).clamp(0.4, 1.4),
        maxThinkDelay: (1.5 - mapSpeedBoost).clamp(0.6, 1.8),
        blockChance: (0.0 + mapIndex * 0.05).clamp(0.0, 0.35),
        comboChance: 0.10,
        jumpChance: 0.08,
        specialChance: 0.15,
        runThreshold: 240,
        hpMultiplier: baseHpMult,
        damageMultiplier: baseDmgMult,
      ),
      2 => AiProfile(
        minThinkDelay: (0.6 - mapSpeedBoost * 0.5).clamp(0.25, 0.8),
        maxThinkDelay: (0.85 - mapSpeedBoost * 0.5).clamp(0.4, 1.0),
        blockChance: (0.35 + mapIndex * 0.06).clamp(0.35, 0.65),
        comboChance: 0.45,
        jumpChance: 0.25,
        specialChance: 0.45,
        runThreshold: 190,
        hpMultiplier: baseHpMult * 1.05,
        damageMultiplier: baseDmgMult * 1.05,
      ),
      _ => AiProfile( // Round 3: Thử thách cực hạn / Boss Thức Tỉnh
        minThinkDelay: (0.22 - mapSpeedBoost * 0.3).clamp(0.12, 0.35),
        maxThinkDelay: (0.38 - mapSpeedBoost * 0.3).clamp(0.20, 0.55),
        blockChance: (0.70 + mapIndex * 0.04).clamp(0.70, 0.90),
        comboChance: 0.85,
        jumpChance: 0.50,
        specialChance: 0.80,
        runThreshold: 150,
        hpMultiplier: baseHpMult * 1.15,
        damageMultiplier: baseDmgMult * 1.15,
      ),
    };
  }
}
