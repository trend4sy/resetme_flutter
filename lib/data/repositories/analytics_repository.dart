import '../models/mood_entry.dart';
import '../models/journal_entry.dart';
import '../models/weekly_analysis.dart';
import 'mood_repository.dart';
import 'journal_repository.dart';

class AnalyticsRepository {
  final MoodRepository _moodRepo;
  final JournalRepository _journalRepo;

  AnalyticsRepository(this._moodRepo, this._journalRepo);

  WeeklyAnalysis generateWeeklyAnalysis() {
    final now = DateTime.now();
    final weekEnd = DateTime(now.year, now.month, now.day);
    final weekStart = weekEnd.subtract(Duration(days: 6));

    final moods = _moodRepo.getMoodsInRange(weekStart, weekEnd);

    final avgStress = moods.isEmpty ? 0.0 :
      moods.fold(0.0, (s, m) => s + m.stressLevel) / moods.length;

    final avgMood = moods.isEmpty ? 0.0 :
      moods.fold(0.0, (s, m) => s + m.moodLevel) / moods.length;

    final sleepMoods = moods.where((m) => m.sleepQuality != null).toList();
    final avgSleep = sleepMoods.isEmpty ? null :
      sleepMoods.fold(0.0, (s, m) => s + m.sleepQuality!) / sleepMoods.length;

    final dailySummaries = _buildDailySummaries(moods, weekStart, weekEnd);
    final pattern = _findPattern(moods);
    final bestExercise = _findBestExercise(moods);

    return WeeklyAnalysis(
      weekStart: weekStart,
      weekEnd: weekEnd,
      avgStress: double.parse(avgStress.toStringAsFixed(1)),
      avgMood: double.parse(avgMood.toStringAsFixed(1)),
      avgSleepQuality: avgSleep != null ? double.parse(avgSleep.toStringAsFixed(1)) : null,
      strongestPattern: pattern,
      strongestPatternEn: pattern,
      bestExerciseId: bestExercise,
      bestExerciseName: bestExercise,
      dailySummaries: dailySummaries,
      nextWeekSuggestion: 'حاول الحفاظ على روتين ثابت قبل النوم هذا الأسبوع',
      nextWeekSuggestionEn: 'Try to maintain a consistent bedtime routine this week',
      isPremium: true,
    );
  }

  List<DailySummary> _buildDailySummaries(List<MoodEntry> moods, DateTime start, DateTime end) {
    final summaries = <DailySummary>[];
    for (var d = start; d.isBefore(end.add(Duration(days: 1))); d = d.add(Duration(days: 1))) {
      final dayMoods = moods.where((m) =>
        m.dateTime.year == d.year &&
        m.dateTime.month == d.month &&
        m.dateTime.day == d.day
      ).toList();

      if (dayMoods.isNotEmpty) {
        final causes = <String, int>{};
        for (final m in dayMoods) {
          causes[m.cause] = (causes[m.cause] ?? 0) + 1;
        }
        final dominant = causes.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        summaries.add(DailySummary(
          date: d,
          avgMood: dayMoods.fold(0.0, (s, m) => s + m.moodLevel) / dayMoods.length,
          avgStress: dayMoods.fold(0.0, (s, m) => s + m.stressLevel) / dayMoods.length,
          sleepQuality: dayMoods.first.sleepQuality?.toDouble(),
          dominantCause: dominant,
        ));
      }
    }
    return summaries;
  }

  String? _findPattern(List<MoodEntry> moods) {
    if (moods.length < 4) return null;
    final eveningHighStress = moods.where((m) =>
      m.stressLevel >= 7 && m.dateTime.hour >= 20
    ).length;
    final nextDayLowSleep = moods.where((m) =>
      m.sleepQuality != null && m.sleepQuality! < 5
    ).length;

    if (eveningHighStress > 2 && nextDayLowSleep > 2) {
      return 'عندما كان التوتر مرتفعًا مساءً، انخفضت جودة النوم في اليوم التالي';
    }
    if (avg(moods.map((m) => m.stressLevel)) > 6) {
      return 'مستوى التوتر كان مرتفعًا هذا الأسبوع';
    }
    return 'مستوى التوتر والنوم كانا مستقرين نسبيًا هذا الأسبوع';
  }

  String? _findBestExercise(List<MoodEntry> moods) {
    if (moods.isEmpty) return null;
    return 'تمرين التنفس';
  }

  double avg(Iterable<num> values) {
    if (values.isEmpty) return 0;
    return values.fold(0.0, (s, v) => s + v) / values.length;
  }
}
