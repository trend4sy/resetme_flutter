import 'package:equatable/equatable.dart';

class BreathingExercise extends Equatable {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String benefit;
  final String benefitEn;
  final List<int> phases;
  final List<String> phaseLabels;
  final List<String> phaseLabelsEn;
  final int totalCycles;
  final int durationSeconds;

  BreathingExercise({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.benefit,
    required this.benefitEn,
    required this.phases,
    required this.phaseLabels,
    required this.phaseLabelsEn,
    this.totalCycles = 5,
    this.durationSeconds = 0,
  });

  int get totalDurationSeconds {
    if (durationSeconds > 0) return durationSeconds;
    final cycleSeconds = phases.fold(0, (sum, p) => sum + p);
    return cycleSeconds * totalCycles;
  }

  static final List<BreathingExercise> all = [
    BreathingExercise(
      id: 'box_breathing',
      title: 'التنفس الصندوقي',
      titleEn: 'Box Breathing',
      description: 'نفس عميق لمدة 4 ثوانٍ، احبس 4، أخرج 4، انتظر 4',
      descriptionEn: 'Inhale 4s, hold 4s, exhale 4s, hold 4s',
      benefit: 'يهدئ الجهاز العصبي بسرعة. مثالي للتوتر المفاجئ.',
      benefitEn: 'Quickly calms the nervous system. Ideal for sudden stress.',
      phases: [4, 4, 4, 4],
      phaseLabels: ['شهيق', 'احبس', 'زفير', 'انتظر'],
      phaseLabelsEn: ['Inhale', 'Hold', 'Exhale', 'Wait'],
      totalCycles: 6,
    ),
    BreathingExercise(
      id: 'breath_478',
      title: '4-7-8',
      titleEn: '4-7-8 Breathing',
      description: 'شهيق 4 ثوانٍ، احبس 7، زفير بطيء 8 ثوانٍ',
      descriptionEn: 'Inhale 4s, hold 7s, slow exhale 8s',
      benefit: 'يساعد على النوم العميق ويخفض القلق.',
      benefitEn: 'Helps deep sleep and reduces anxiety.',
      phases: [4, 7, 8],
      phaseLabels: ['شهيق', 'احبس', 'زفير'],
      phaseLabelsEn: ['Inhale', 'Hold', 'Exhale'],
      totalCycles: 4,
    ),
    BreathingExercise(
      id: 'physiological_sigh',
      title: 'التنفس المزدوج',
      titleEn: 'Physiological Sigh',
      description: 'شهيق مزدوج (شهيق + شهيق قصير) ثم زفير بطيء طويل',
      descriptionEn: 'Double inhale + long slow exhale',
      benefit: 'أسرع طريقة لخفض التوتر الفسيولوجي. يريح الحجاب الحاجز.',
      benefitEn: 'Fastest way to lower physiological stress. Relaxes diaphragm.',
      phases: [2, 2, 6],
      phaseLabels: ['شهيق أول', 'شهيق ثانٍ', 'زفير طويل'],
      phaseLabelsEn: ['First Inhale', 'Second Inhale', 'Long Exhale'],
      totalCycles: 8,
    ),
  ];

  @override
  List<Object?> get props => [id, title, phases, totalCycles];
}
