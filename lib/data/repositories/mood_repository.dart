import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/supabase_service.dart';

class MoodRepository {
  final HiveService _local;
  final SupabaseService _remote;

  MoodRepository(this._local, this._remote);

  Future<MoodEntry> saveMood(MoodEntry entry) async {
    final saved = entry.copyWith(id: entry.id.isEmpty ? Uuid().v4() : entry.id);
    await _local.saveMood(saved);
    if (_remote.isSignedIn) {
      try {
        await _remote.syncMood(saved);
      } catch (_) {}
    }
    return saved;
  }

  List<MoodEntry> getMoods() => _local.getMoods();
  List<MoodEntry> getMoodsInRange(DateTime start, DateTime end) =>
    _local.getMoodsInRange(start, end);

  MoodEntry? getTodayMood() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(Duration(days: 1));
    final moods = getMoodsInRange(start, end);
    return moods.isNotEmpty ? moods.first : null;
  }

  bool hasCheckedInToday() => getTodayMood() != null;

  Future<void> syncFromRemote() async {
    if (!_remote.isSignedIn) return;
    final lastWeek = DateTime.now().subtract(Duration(days: 7));
    final remoteMoods = await _remote.fetchMoodsSince(lastWeek);
    for (final mood in remoteMoods) {
      await _local.saveMood(mood);
    }
  }

  Map<String, double> getWeeklyAverages() {
    final weekStart = DateTime.now().subtract(Duration(days: 7));
    final moods = getMoodsInRange(weekStart, DateTime.now());
    if (moods.isEmpty) return {'mood': 3.0, 'stress': 5.0, 'sleep': 5.0};

    return {
      'mood': moods.fold(0, (s, m) => s + m.moodLevel) / moods.length,
      'stress': moods.fold(0, (s, m) => s + m.stressLevel) / moods.length,
      'sleep': moods.where((m) => m.sleepQuality != null).fold(0, (s, m) => s + m.sleepQuality!) /
        (moods.where((m) => m.sleepQuality != null).length).toDouble().clamp(1, double.infinity),
    };
  }

  String? getMostCommonCause() {
    final weekStart = DateTime.now().subtract(Duration(days: 7));
    final moods = getMoodsInRange(weekStart, DateTime.now());
    if (moods.isEmpty) return null;
    final causes = <String, int>{};
    for (final m in moods) {
      causes[m.cause] = (causes[m.cause] ?? 0) + 1;
    }
    return causes.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
