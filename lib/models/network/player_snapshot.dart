class PlayerSnapshot {
  final double x;
  final double y;
  final double hp;
  final bool facingRight;
  final String state;

  const PlayerSnapshot({
    required this.x,
    required this.y,
    required this.hp,
    required this.facingRight,
    required this.state,
  });

  factory PlayerSnapshot.fromCharacter({
    required double x,
    required double y,
    required double hp,
    required bool facingRight,
    required String state,
  }) => PlayerSnapshot(x: x, y: y, hp: hp, facingRight: facingRight, state: state);

  Map<String, Object?> toJson() => {
    'x': x,
    'y': y,
    'hp': hp,
    'facingRight': facingRight,
    'state': state,
  };

  factory PlayerSnapshot.fromJson(Map<String, dynamic> json) => PlayerSnapshot(
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    hp: (json['hp'] as num).toDouble(),
    facingRight: json['facingRight'] == true,
    state: json['state'] as String? ?? 'idle',
  );
}
