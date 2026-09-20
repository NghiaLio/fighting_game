import 'package:fighting_game/enums/character_type.dart';
import 'package:fighting_game/utils/select_per_tileset.dart';
import 'package:flutter/material.dart';

/// Thông tin chi tiết của một anh hùng trong danh sách chọn tướng
class HeroInfo {
  final CharacterType type;
  final String name;
  final String title;
  final String role;
  final SelectPerTile pillarTile;
  final SelectPerTile badgeTile;
  final SelectPerTile gemTile;
  final Color primaryColor;
  final double atkRating;
  final double defRating;
  final double spdRating;
  final double rngRating;
  final String ultimateName;
  final String description;
  final int idleFrames;

  const HeroInfo({
    required this.type,
    required this.name,
    required this.title,
    required this.role,
    required this.pillarTile,
    required this.badgeTile,
    required this.gemTile,
    required this.primaryColor,
    required this.atkRating,
    required this.defRating,
    required this.spdRating,
    required this.rngRating,
    required this.ultimateName,
    required this.description,
    required this.idleFrames,
  });

  /// Lấy danh xưng ngắn gọn của chức nghiệp (ví dụ: 'Pháp Sư', 'Đấu Sĩ', 'Sát Thủ')
  String get shortRole => role.split(' - ').first;
}
