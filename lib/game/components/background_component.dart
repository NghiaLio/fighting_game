import 'package:fighting_game/constants/app_assets.dart';
import 'package:fighting_game/game/fighting_game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

/// Extended repeating background that seamlessly tiles across the entire map.
class BackgroundComponent extends PositionComponent
    with HasGameReference<FightingGame> {
  final double mapWidth;
  Sprite? _bgSprite;

  BackgroundComponent({required this.mapWidth}) : super(priority: -1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _bgSprite = Sprite(Flame.images.fromCache(AppAssets.arenaBg1));
    size = Vector2(mapWidth, game.size.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_bgSprite == null) return;

    final tileW = game.size.x;
    final tileH = game.size.y;
    int index = 0;

    // Seamless mirror tiling: alternate flipping each slice horizontally
    // so borders blend naturally into one continuous forest arena
    for (double x = 0; x < mapWidth; x += tileW) {
      final isFlipped = index % 2 == 1;
      canvas.save();
      if (isFlipped) {
        canvas.translate(x + tileW, 0);
        canvas.scale(-1, 1);
      } else {
        canvas.translate(x, 0);
      }
      _bgSprite!.render(canvas, size: Vector2(tileW, tileH));
      canvas.restore();
      index++;
    }
  }
}
