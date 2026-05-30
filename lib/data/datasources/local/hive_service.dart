import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/mood_entry.dart';
import '../../models/journal_entry.dart';
import '../../models/user_profile.dart';
import '../../models/weekly_analysis.dart';

class HiveService {
  static const String _moodBox = 'moods';
  static const String _journalBox = 'journals';
  static const String _profileBox = 'profile';
  static const String _analyticsBox = 'analytics';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_moodBox);
    await Hive.openBox<String>(_journalBox);
    await Hive.openBox<String>(_profileBox);
    await Hive.openBox<String>(_analyticsBox);
  }

  Box<String> get _moods => Hive.box<String>(_moodBox);
  Box<String> get _journals => Hive.box<String>(_journalBox);
  Box<String> get _profile => Hive.box<String>(_profileBox);
  Box<String> get _analytics => Hive.box<String>(_analyticsBox);

  String _key(String prefix, DateTime date) =>
    '${prefix}_${date.year}_${date.month}_${date.day}_${date.hour}_${date.minute}_${date.second}';

  Future<void> saveMood(MoodEntry entry) async {
    await _moods.put(_key('mood', entry.dateTime), entry.toJson().toString());
  }

  List<MoodEntry> getMoods() {
    return _moods.values.map((v) {
      try {
        return MoodEntry.fromJson(_parseJson(v));
      } catch (_) {
        return null;
      }
    }).whereType<MoodEntry>().toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  List<MoodEntry> getMoodsInRange(DateTime start, DateTime end) {
    return getMoods().where((m) =>
      m.dateTime.isAfter(start.subtract(Duration(days: 1))) &&
      m.dateTime.isBefore(end.add(Duration(days: 1)))
    ).toList();
  }

  Future<void> saveJournal(JournalEntry entry) async {
    await _journals.put(_key('journal', entry.dateTime), entry.toJson().toString());
  }

  List<JournalEntry> getJournals() {
    return _journals.values.map((v) {
      try {
        return JournalEntry.fromJson(_parseJson(v));
      } catch (_) {
        return null;
      }
    }).whereType<JournalEntry>().toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _profile.put('profile', profile.toJson().toString());
  }

  UserProfile? getProfile() {
    final v = _profile.get('profile');
    if (v == null) return null;
    try {
      return UserProfile.fromJson(_parseJson(v));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveWeeklyAnalysis(WeeklyAnalysis analysis) async {
    await _analytics.put(
      'weekly_${analysis.weekStart.toIso8601String()}',
      analysis.toJson().toString(),
    );
  }

  WeeklyAnalysis? getWeeklyAnalysis(DateTime weekStart) {
    final v = _analytics.get('weekly_${weekStart.toIso8601String()}');
    if (v == null) return null;
    try {
      return WeeklyAnalysis.fromJson(_parseJson(v));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    await _moods.clear();
    await _journals.clear();
    await _profile.clear();
    await _analytics.clear();
  }

  Map<String, dynamic> _parseJson(String raw) {
    final result = <String, dynamic>{};
    final pairs = raw.substring(1, raw.length - 1).split(', ');
    for (final pair in pairs) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        var value = parts[1].trim();
        if (value == 'null') {
          result[parts[0].trim()] = null;
        } else if (value.startsWith('{') || value.startsWith('[')) {
          result[parts[0].trim()] = value;
        } else if (value.toLowerCase() == 'true') {
          result[parts[0].trim()] = true;
        } else if (value.toLowerCase() == 'false') {
          result[parts[0].trim()] = false;
        } else if (double.tryParse(value) != null) {
          result[parts[0].trim()] = double.parse(value);
        } else {
          result[parts[0].trim()] = value.replaceAll("'", "").replaceAll('"', '');
        }
      }
    }
    return result;
  }
}
