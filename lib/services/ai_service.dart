import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class AiService {
  final String _apiUrl;
  final String? _apiKey;

  AiService({String? apiUrl, String? apiKey})
    : _apiUrl = apiUrl ?? AppConstants.openAiApiUrl,
      _apiKey = apiKey;

  Future<String?> analyzeJournal(String text, {String language = 'ar'}) async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;
    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': language == 'ar'
                ? 'أنت مساعد دعم نفسي. حلل النص بهدوء وتعاطف. أعط ملاحظة قصيرة جدًا (جملة واحدة). لا تشخص. لا تقل "قلق" أو "اكتئاب". ركز على المشاعر والعادات.'
                : 'You are a mental wellness assistant. Analyze the text calmly. Give one short sentence. Do not diagnose. Do not say "anxiety" or "depression". Focus on feelings and habits.',
            },
            {'role': 'user', 'content': text},
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['choices']?[0]?['message']?['content'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> generateWeeklyInsight(
    double avgStress,
    double avgMood,
    double? avgSleep,
    String dominantCause,
    {String language = 'ar'}
  ) async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;
    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': language == 'ar'
                ? 'لخص أسبوع المستخدم بجملتين. كن داعمًا. لا تشخص. اقترح شيئًا واحدًا للأسبوع القادم.'
                : 'Summarize the user week in 2 sentences. Be supportive. Do not diagnose. Suggest one thing for next week.',
            },
            {
              'role': 'user',
              'content': language == 'ar'
                ? 'متوسط التوتر: $avgStress/10، المزاج: $avgMood/5، النوم: ${avgSleep ?? "غير مسجل"}/10، السبب الأكثر شيوعاً: $dominantCause'
                : 'Avg stress: $avgStress/10, mood: $avgMood/5, sleep: ${avgSleep ?? "N/A"}/10, top cause: $dominantCause',
            },
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['choices']?[0]?['message']?['content'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> reframeThought(String thought, {String language = 'ar'}) async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;
    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': language == 'ar'
                ? 'اعد صياغة الفكرة السلبية بطريقة أهدأ وأكثر واقعية. جملة واحدة فقط.'
                : 'Reframe the negative thought in a calmer, more realistic way. One sentence only.',
            },
            {'role': 'user', 'content': thought},
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['choices']?[0]?['message']?['content'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> generateSuggestedRoutine(
    int stress, int mood, int? sleepQuality, String cause, String timeOfDay,
    {String language = 'ar'}
  ) async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;
    try {
      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': language == 'ar'
                ? 'اقترح روتينًا قصيرًا (جملتين) بناءً على الحالة. مثال: "توترك مرتفع. جرب 3 دقائق تنفس صندوقي + 5 دقائق تفريغ أفكار."'
                : 'Suggest a short routine (2 sentences) based on state. Example: "Stress is high. Try 3 min box breathing + 5 min brain dump."',
            },
            {
              'role': 'user',
              'content': language == 'ar'
                ? 'التوتر: $stress/10، المزاج: $mood/5، النوم: ${sleepQuality ?? "غير معروف"}/10، السبب: $cause، الوقت: $timeOfDay'
                : 'Stress: $stress/10, Mood: $mood/5, Sleep: ${sleepQuality ?? "N/A"}/10, Cause: $cause, Time: $timeOfDay',
            },
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['choices']?[0]?['message']?['content'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
