import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/mood_entry.dart';
import '../../models/journal_entry.dart';
import '../../models/user_profile.dart';

class SupabaseService {
  late final SupabaseClient _client;
  bool _initialized = false;

  Future<void> init(String url, String anonKey) async {
    if (_initialized) return;
    await Supabase.initialize(url: url, anonKey: anonKey);
    _client = Supabase.instance.client;
    _initialized = true;
  }

  SupabaseClient get client => _client;
  bool get isInitialized => _initialized;
  bool get isSignedIn => _initialized && _client.auth.currentSession != null;
  String? get userId => _client.auth.currentUser?.id;

  Future<void> signInAnonymously() async {
    await _client.auth.signInAnonymously();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> syncMood(MoodEntry entry) async {
    if (!isSignedIn) return;
    await _client.from('mood_entries').upsert(entry.toJson());
  }

  Future<void> syncJournal(JournalEntry entry) async {
    if (!isSignedIn) return;
    await _client.from('journal_entries').upsert(entry.toJson());
  }

  Future<void> syncProfile(UserProfile profile) async {
    if (!isSignedIn || userId == null) return;
    await _client.from('profiles').upsert({
      ...profile.toJson(),
      'id': userId,
    });
  }

  Future<UserProfile?> fetchProfile() async {
    if (!isSignedIn || userId == null) return null;
    final res = await _client.from('profiles').select().eq('id', userId!).single();
    return UserProfile.fromJson(res);
  }

  Future<List<MoodEntry>> fetchMoodsSince(DateTime since) async {
    if (!isSignedIn || userId == null) return [];
    final res = await _client
      .from('mood_entries')
      .select()
      .gte('date_time', since.toIso8601String())
      .order('date_time', ascending: false);
    return (res as List).map((e) => MoodEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<JournalEntry>> fetchJournalsSince(DateTime since) async {
    if (!isSignedIn || userId == null) return [];
    final res = await _client
      .from('journal_entries')
      .select()
      .gte('date_time', since.toIso8601String())
      .order('date_time', ascending: false);
    return (res as List).map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>?> fetchRemoteConfig() async {
    if (!isInitialized) return null;
    try {
      final res = await _client.from('app_config').select().single();
      return res as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> callAiFunction(String endpoint, Map<String, dynamic> body) async {
    if (!isSignedIn) return null;
    try {
      final res = await _client.functions.invoke(endpoint, body: body);
      return res.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }
}
