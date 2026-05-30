import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'data/datasources/local/hive_service.dart';
import 'data/datasources/remote/supabase_service.dart';
import 'data/repositories/mood_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/routine_repository.dart';
import 'data/repositories/analytics_repository.dart';
import 'services/subscription_service.dart';
import 'services/audio_service.dart';
import 'services/notification_service.dart';
import 'services/ai_service.dart';
import 'services/breathing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  final hiveService = HiveService();
  final supabaseService = SupabaseService();

  final supabaseUrl = AppConstants.supabaseUrl;
  final supabaseKey = AppConstants.supabaseAnonKey;
  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await supabaseService.init(supabaseUrl, supabaseKey);
  }

  final subscriptionService = SubscriptionService(hiveService);
  await subscriptionService.init();

  final profile = hiveService.getProfile();
  final isDark = profile?.darkMode ?? false;

  runApp(ResetMeApp(darkMode: isDark));
}

class AppDependencies {
  static final hiveService = HiveService();
  static final supabaseService = SupabaseService();
  static final moodRepo = MoodRepository(hiveService, supabaseService);
  static final journalRepo = JournalRepository(hiveService, supabaseService);
  static final routineRepo = RoutineRepository();
  static final analyticsRepo = AnalyticsRepository(moodRepo, journalRepo);
  static final subscriptionService = SubscriptionService(hiveService);
  static final audioService = AudioService();
  static final notificationService = NotificationService();
  static final aiService = AiService();
  static final breathingService = BreathingService();
}
