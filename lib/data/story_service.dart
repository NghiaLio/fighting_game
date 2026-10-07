import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StoryData {
  final String title;
  final String subtitle;
  final String content;

  const StoryData({
    required this.title,
    required this.subtitle,
    required this.content,
  });

  factory StoryData.fromJson(Map<String, dynamic> json) {
    return StoryData(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class StageStory {
  final int stageNumber;
  final String title;
  final String story;

  const StageStory({
    required this.stageNumber,
    required this.title,
    required this.story,
  });

  factory StageStory.fromJson(Map<String, dynamic> json) {
    return StageStory(
      stageNumber: json['stageNumber'] ?? 0,
      title: json['title'] ?? '',
      story: json['story'] ?? '',
    );
  }
}

class StoryService {
  static StoryData? _overallStory;
  static Map<int, StageStory> _stageStories = {};
  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/config/story.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;

      _overallStory = StoryData.fromJson(
        data['overallStory'] as Map<String, dynamic>,
      );

      final stagesList = data['stages'] as List<dynamic>?;
      if (stagesList != null) {
        for (final item in stagesList) {
          final ss = StageStory.fromJson(item as Map<String, dynamic>);
          _stageStories[ss.stageNumber] = ss;
        }
      }
      _loaded = true;
    } catch (e) {
      _loaded = false;
    }
  }

  static StoryData? get overallStory => _overallStory;

  static StageStory? getStageStory(int stageNumber) =>
      _stageStories[stageNumber];
}
