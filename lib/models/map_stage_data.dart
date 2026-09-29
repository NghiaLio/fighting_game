import 'package:fighting_game/utils/map_tileset.dart';
import 'package:flutter/material.dart';

/// Dữ liệu mô tả 1 màn chơi trên Bản Đồ Chiến Dịch
class MapStageData {
  final int stageNumber;
  final String title;
  final MapTile tile;
  final Offset relativePos; // (0.0 -> 1.0) theo chiều rộng & chiều cao bản đồ
  final int stars; // 0..3
  final bool isUnlocked;
  final String description;
  final String bossName;

  const MapStageData({
    required this.stageNumber,
    required this.title,
    required this.tile,
    required this.relativePos,
    this.stars = 0,
    this.isUnlocked = true,
    this.description = '',
    this.bossName = 'Chiến Binh Hắc Ám',
  });
}
