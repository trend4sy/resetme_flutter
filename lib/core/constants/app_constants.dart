class AppConstants {
  AppConstants._();

  static const String appName = 'ResetMe';
  static const String appNameArabic = 'ريست مي';
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String openAiApiUrl = String.fromEnvironment('OPENAI_API_URL',
    defaultValue: 'https://api.openai.com/v1/chat/completions');
  static const String revenueCatApiKey = String.fromEnvironment('REVENUECAT_API_KEY');

  static const int minVentingChars = 10;
  static const int maxVentingChars = 1000;
  static const int minGratitudeChars = 5;
  static const int maxGratitudeChars = 500;

  static const int freeMoodCheckinsPerDay = 999;
  static const int freeBreathingExercises = 3;
  static const int freeMeditations = 4;
  static const int freeSoundsCount = 1;
  static const bool freeHasWeeklyAnalytics = true;
  static const bool freeHasAiAssistant = false;
  static const bool freeHasJournalVenting = true;
  static const bool freeHasJournalGratitude = false;

  static const List<String> moodOptions = ['هادئ', 'متوتر', 'مرهق', 'حزين', 'مشتت', 'لا أستطيع النوم'];
  static const List<String> moodOptionsEn = ['Calm', 'Stressed', 'Tired', 'Sad', 'Distracted', 'Can\'t sleep'];
  static const List<String> stressCauses = ['عمل', 'دراسة', 'مال', 'علاقة', 'صحة', 'غير معروف'];
  static const List<String> stressCausesEn = ['Work', 'Study', 'Money', 'Relationship', 'Health', 'Unknown'];

  static const List<int> checkinEmojis = [0x1F60A, 0x1F614, 0x1F634, 0x1F622, 0x1F635, 0x1F62D];
}
