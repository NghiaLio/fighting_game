import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';

/// Cấu hình âm thanh kỹ năng (Skill Audio) cho từng nhân vật trong game
/// - Mỗi nhân vật có đúng 4 chiêu thức: Attack 1, Attack 2, Attack 3, Special
/// - Cung cấp nơi cấu hình riêng biệt, dễ dàng mở rộng thêm sound cho các nhân vật tiếp theo
class CharacterSkillAudio {
  final String attack1;
  final String attack2;
  final String attack3;
  final String special;

  const CharacterSkillAudio({
    required this.attack1,
    required this.attack2,
    required this.attack3,
    required this.special,
  });

  /// Trả về tên file SFX tương ứng với trạng thái tấn công của nhân vật
  String? getSfxForState(CharacterState state) => switch (state) {
        CharacterState.attack1 => attack1,
        CharacterState.attack2 => attack2,
        CharacterState.attack3 => attack3,
        CharacterState.special => special,
        _ => null,
      };

  /// Bảng tra cứu âm thanh kỹ năng cho từng loại tướng
  /// - Hiện tại: cấu hình chuẩn cho tướng [CharacterType.fireWizard] (đúng 4 chiêu)
  /// - Các nhân vật khác có thể dễ dàng bổ sung tại đây khi có tài nguyên âm thanh
  static CharacterSkillAudio? fromCharacterType(CharacterType type) =>
      switch (type) {
        // Tướng hiện tại: Fire Wizard (đúng 4 chiêu)
        // 1. Chiêu 1: attac_2.mp3
        // 2. Chiêu 2: attack_1.mp3
        // 3. Chiêu 3: sfx_fire_whoosh.mp3
        // 4. Chiêu 4 (Special): sfx_fireball_launch_[cut_2sec].wav
        CharacterType.fireWizard => const CharacterSkillAudio(
            attack1: AppAssets.sfxAttack2,
            attack2: AppAssets.sfxAttack1,
            attack3: AppAssets.sfxFireWhoosh,
            special: AppAssets.sfxFireballLaunch,
          ),

        // Các tướng khác (sẽ bổ sung khi có sound):
        _ => null,
      };
}
