class FeatureFlags {
  FeatureFlags._();

  static Map<String, bool> _flags = {
    'breathing_exercises': true,
    'box_breathing': true,
    'breath_478': true,
    'physiological_sigh': true,
    'meditations': true,
    'journal_venting': true,
    'journal_gratitude': false,
    'sleep_routine': true,
    'ambient_sounds': true,
    'weekly_analytics_basic': true,
    'weekly_analytics_advanced': false,
    'ai_assistant': false,
    'ai_insights': false,
    'ai_reframe': false,
    'dark_mode': true,
    'multi_language': true,
  };

  static bool isPremium(String feature) {
    return _flags.containsKey('${feature}_premium') && _flags['${feature}_premium'] == true;
  }

  static bool isEnabled(String feature) {
    return _flags[feature] ?? false;
  }

  static void updateFromRemote(Map<String, dynamic> remote) {
    _flags.addAll(remote.map((k, v) => MapEntry(k, v as bool)));
  }

  static Map<String, bool> get all => Map.unmodifiable(_flags);
}
