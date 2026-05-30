import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/hive_service.dart';
import '../core/constants/feature_flags.dart';

class SubscriptionService {
  final HiveService _hive;
  bool _isPremium = false;

  SubscriptionService(this._hive);

  bool get isPremium => _isPremium;

  Future<void> init() async {
    final profile = _hive.getProfile();
    _isPremium = profile?.isPremium ?? false;
    _updateFlags();
  }

  bool hasAccess(String feature) {
    if (!_isPremium) {
      final freeFeatures = {
        'breathing_exercises', 'box_breathing', 'breath_478',
        'physiological_sigh', 'meditations_limited', 'journal_venting',
        'sleep_routine', 'ambient_sounds_limited', 'weekly_analytics_basic',
        'dark_mode', 'multi_language',
      };
      if (freeFeatures.contains(feature)) return true;
      return false;
    }
    return true;
  }

  void setPremium(bool value) {
    _isPremium = value;
    _updateFlags();
  }

  void _updateFlags() {
    FeatureFlags.updateFromRemote({
      'journal_gratitude': _isPremium,
      'weekly_analytics_advanced': _isPremium,
      'ai_assistant': _isPremium,
      'ai_insights': _isPremium,
      'ai_reframe': _isPremium,
    });
  }
}

final subscriptionProvider = Provider<SubscriptionService>((ref) {
  throw UnimplementedError('Must override');
});
