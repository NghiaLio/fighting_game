import 'package:fighting_game/enums/character_state.dart';
import 'package:fighting_game/enums/character_type.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

SpriteAnimation getPlayerAnimation({
  required CharacterType characterType,
  required CharacterState characterState,
  required double stepTime,
  required bool loop,
}) {
  final image = Flame.images.fromCache(
    '${characterType.spritePath}/${characterState.spritePath}',
  );
  final frameCount = image.width ~/ 128;
  return SpriteAnimation.fromFrameData(
    image,
    SpriteAnimationData.sequenced(
      amount: frameCount > 0 ? frameCount : 1,
      stepTime: stepTime,
      textureSize: Vector2(128, 128),
      loop: loop,
    ),
  );
}
