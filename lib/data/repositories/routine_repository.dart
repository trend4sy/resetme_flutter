import '../models/routine.dart';

class RoutineRepository {
  static List<Routine> _buildCalmRoutine() => [
    Routine(
      id: 'calm_morning',
      title: 'بداية هادئة',
      titleEn: 'Calm Start',
      description: 'روتين صباحي قصير لبداية يوم هادئة',
      descriptionEn: 'Short morning routine for a calm start',
      context: 'صباح',
      contextEn: 'Morning',
      steps: [
        RoutineStep(id: 's1', type: RoutineStepType.breathing, title: 'تنفس صندوقي', titleEn: 'Box Breathing', durationMinutes: 3, exerciseId: 'box_breathing'),
        RoutineStep(id: 's2', type: RoutineStepType.gratitude, title: 'امتنان', titleEn: 'Gratitude', durationMinutes: 2, prompt: 'اكتب شيئًا واحدًا أنت ممتن له اليوم', promptEn: 'Write one thing you\'re grateful for today'),
      ],
    ),
    Routine(
      id: 'stress_relief',
      title: 'تهدئة سريعة',
      titleEn: 'Quick Calm',
      description: 'عندما تحتاج لخفض التوتر بسرعة',
      descriptionEn: 'When you need to lower stress quickly',
      context: 'توتر',
      contextEn: 'Stress',
      steps: [
        RoutineStep(id: 's3', type: RoutineStepType.breathing, title: 'تنفس مزدوج', titleEn: 'Physiological Sigh', durationMinutes: 3, exerciseId: 'physiological_sigh'),
        RoutineStep(id: 's4', type: RoutineStepType.reflection, title: 'تفريغ سريع', titleEn: 'Quick Vent', durationMinutes: 3, prompt: 'ما سبب التوتر الآن؟', promptEn: 'What\'s causing stress right now?'),
      ],
    ),
    Routine(
      id: 'evening_wind_down',
      title: 'مساء هادئ',
      titleEn: 'Evening Wind Down',
      description: 'استعد لنوم هادئ',
      descriptionEn: 'Prepare for restful sleep',
      context: 'مساء',
      contextEn: 'Evening',
      steps: [
        RoutineStep(id: 's5', type: RoutineStepType.journal, title: 'تفريغ الأفكار', titleEn: 'Brain Dump', durationMinutes: 5, prompt: 'اكتب كل ما يشغل بالك', promptEn: 'Write everything on your mind'),
        RoutineStep(id: 's6', type: RoutineStepType.breathing, title: 'تنفس 4-7-8', titleEn: '4-7-8 Breathing', durationMinutes: 3, exerciseId: 'breath_478'),
        RoutineStep(id: 's7', type: RoutineStepType.sound, title: 'صوت هادئ', titleEn: 'Calm Sound', durationMinutes: 7, soundId: 'rain'),
      ],
    ),
  ];

  static List<Routine> _buildStressRoutine() => [
    Routine(
      id: 'stress_breathing',
      title: 'تنفس عميق',
      titleEn: 'Deep Breathing',
      description: 'تمارين تنفس لتخفيف التوتر',
      descriptionEn: 'Breathing exercises for stress relief',
      context: 'توتر',
      contextEn: 'Stress',
      steps: [
        RoutineStep(id: 's8', type: RoutineStepType.breathing, title: 'تنفس صندوقي', titleEn: 'Box Breathing', durationMinutes: 4, exerciseId: 'box_breathing'),
        RoutineStep(id: 's9', type: RoutineStepType.breathing, title: 'تنفس مزدوج', titleEn: 'Physiological Sigh', durationMinutes: 2, exerciseId: 'physiological_sigh'),
        RoutineStep(id: 's10', type: RoutineStepType.sound, title: 'صوت مطر', titleEn: 'Rain Sound', durationMinutes: 6, soundId: 'rain'),
      ],
    ),
    Routine(
      id: 'stress_journal',
      title: 'تفريغ توتر',
      titleEn: 'Stress Release',
      description: 'اكتب وتنفس لتخفيف الضغط',
      descriptionEn: 'Write and breathe to release pressure',
      context: 'توتر',
      contextEn: 'Stress',
      isPremium: true,
      steps: [
        RoutineStep(id: 's11', type: RoutineStepType.journal, title: 'تفريغ', titleEn: 'Vent', durationMinutes: 5, prompt: 'اكتب كل ما يزعجك الآن', promptEn: 'Write everything bothering you now'),
        RoutineStep(id: 's12', type: RoutineStepType.breathing, title: 'تنفس مزدوج', titleEn: 'Physiological Sigh', durationMinutes: 3, exerciseId: 'physiological_sigh'),
        RoutineStep(id: 's13', type: RoutineStepType.meditation, title: 'تأمل قصير', titleEn: 'Short Meditation', durationMinutes: 5),
      ],
    ),
  ];

  static List<Routine> _buildSleepRoutine() => [
    Routine(
      id: 'sleep_basic',
      title: 'نوم هادئ',
      titleEn: 'Peaceful Sleep',
      description: 'روتين قصير قبل النوم',
      descriptionEn: 'Short pre-sleep routine',
      context: 'نوم',
      contextEn: 'Sleep',
      steps: [
        RoutineStep(id: 's14', type: RoutineStepType.journal, title: 'تفريغ أفكار', titleEn: 'Brain Dump', durationMinutes: 3, prompt: 'ما الذي يشغل بالك قبل النوم؟', promptEn: 'What\'s on your mind before sleep?'),
        RoutineStep(id: 's15', type: RoutineStepType.breathing, title: 'تنفس 4-7-8', titleEn: '4-7-8 Breathing', durationMinutes: 3, exerciseId: 'breath_478'),
        RoutineStep(id: 's16', type: RoutineStepType.sound, title: 'صوت هادئ', titleEn: 'Calm Sound', durationMinutes: 10, soundId: 'rain'),
      ],
    ),
    Routine(
      id: 'sleep_deep',
      title: 'نوم عميق',
      titleEn: 'Deep Sleep',
      description: 'روتين كامل لنوم عميق',
      descriptionEn: 'Complete deep sleep routine',
      context: 'نوم',
      contextEn: 'Sleep',
      isPremium: true,
      steps: [
        RoutineStep(id: 's17', type: RoutineStepType.reflection, title: 'إغلاق اليوم', titleEn: 'Day Closure', durationMinutes: 3, prompt: 'ما أجمل شيء حدث اليوم؟', promptEn: 'What was the best thing today?'),
        RoutineStep(id: 's18', type: RoutineStepType.journal, title: 'تفريغ', titleEn: 'Brain Dump', durationMinutes: 5, prompt: 'فرغ أفكارك', promptEn: 'Clear your mind'),
        RoutineStep(id: 's19', type: RoutineStepType.breathing, title: 'تنفس 4-7-8', titleEn: '4-7-8 Breathing', durationMinutes: 3, exerciseId: 'breath_478'),
        RoutineStep(id: 's20', type: RoutineStepType.meditation, title: 'تأمل نوم', titleEn: 'Sleep Meditation', durationMinutes: 7),
        RoutineStep(id: 's21', type: RoutineStepType.sound, title: 'صوت', titleEn: 'Sound', durationMinutes: 15, soundId: 'rain'),
      ],
    ),
  ];

  List<Routine> getAllRoutines(String context) {
    final all = [
      ..._buildCalmRoutine(),
      ..._buildStressRoutine(),
      ..._buildSleepRoutine(),
    ];
    if (context.isEmpty) return all;
    return all.where((r) => r.context == context).toList();
  }

  Routine? getRoutineById(String id) {
    final all = [
      ..._buildCalmRoutine(),
      ..._buildStressRoutine(),
      ..._buildSleepRoutine(),
    ];
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Routine? recommendRoutine(String mood, int stress, int? sleepQuality, String timeOfDay) {
    if (timeOfDay == 'مساء' || timeOfDay == 'Evening' || timeOfDay == 'قبل النوم' || timeOfDay == 'Before sleep') {
      if (sleepQuality != null && sleepQuality < 5) {
        return _buildSleepRoutine().firstWhere((r) => r.id == 'sleep_basic');
      }
      return _buildSleepRoutine().firstWhere((r) => r.id == 'sleep_basic');
    }

    if (stress >= 7) {
      return _buildStressRoutine().firstWhere((r) => r.id == 'stress_breathing');
    }

    if (mood == 'متوتر' || mood == 'Stressed' || mood == 'مشتت' || mood == 'Distracted') {
      return _buildStressRoutine().firstWhere((r) => r.id == 'stress_breathing');
    }

    return _buildCalmRoutine().firstWhere((r) => r.id == 'calm_morning');
  }
}
