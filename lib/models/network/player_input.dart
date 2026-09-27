class PlayerInput {
  final int sequence;
  final bool left;
  final bool right;
  final bool sprint;
  final bool jump;
  final int action;

  const PlayerInput({
    required this.sequence,
    this.left = false,
    this.right = false,
    this.sprint = false,
    this.jump = false,
    this.action = 0,
  });

  factory PlayerInput.fromPacket(Map<String, dynamic> packet) => PlayerInput(
    sequence: packet['sequence'] is int ? packet['sequence'] as int : 0,
    left: packet['left'] == true,
    right: packet['right'] == true,
    sprint: packet['sprint'] == true,
    jump: packet['jump'] == true,
    action: packet['action'] is int ? packet['action'] as int : 0,
  );

  Map<String, Object?> toPacket() => {
    'type': 'input',
    'left': left,
    'right': right,
    'sprint': sprint,
    'jump': jump,
    'action': action,
  };
}
