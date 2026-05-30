import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/supabase_service.dart';

class JournalRepository {
  final HiveService _local;
  final SupabaseService _remote;

  JournalRepository(this._local, this._remote);

  Future<JournalEntry> saveEntry(JournalEntry entry) async {
    final saved = entry.copyWith(id: entry.id.isEmpty ? Uuid().v4() : entry.id);
    await _local.saveJournal(saved);
    if (_remote.isSignedIn) {
      try {
        await _remote.syncJournal(saved);
      } catch (_) {}
    }
    return saved;
  }

  List<JournalEntry> getEntries() => _local.getJournals();

  List<JournalEntry> getByType(JournalType type) =>
    _local.getJournals().where((e) => e.type == type).toList();

  int getEntryCountForToday(JournalType type) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(Duration(days: 1));
    return _local.getJournals().where((e) =>
      e.type == type &&
      e.dateTime.isAfter(start) &&
      e.dateTime.isBefore(end)
    ).length;
  }

  Future<void> syncFromRemote() async {
    if (!_remote.isSignedIn) return;
    final lastWeek = DateTime.now().subtract(Duration(days: 7));
    final remote = await _remote.fetchJournalsSince(lastWeek);
    for (final entry in remote) {
      await _local.saveJournal(entry);
    }
  }
}
