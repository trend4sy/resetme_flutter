import 'package:equatable/equatable.dart';

enum RoutineStepType {
  breathing,
  meditation,
  journal,
  sound,
  reflection,
  gratitude,
}

class RoutineStep extends Equatable {
  final String id;
  final RoutineStepType type;
  final String title;
  final String titleEn;
  final int durationMinutes;
  final String? exerciseId;
  final String? soundId;
  final String? prompt;
  final String? promptEn;

  RoutineStep({
    required this.id,
    required this.type,
    required this.title,
    required this.titleEn,
    required this.durationMinutes,
    this.exerciseId,
    this.soundId,
    this.prompt,
    this.promptEn,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'title': title,
    'title_en': titleEn,
    'duration_minutes': durationMinutes,
    'exercise_id': exerciseId,
    'sound_id': soundId,
    'prompt': prompt,
    'prompt_en': promptEn,
  };

  factory RoutineStep.fromJson(Map<String, dynamic> json) => RoutineStep(
    id: json['id'] as String,
    type: RoutineStepType.values.firstWhere((e) => e.name == json['type']),
    title: json['title'] as String,
    titleEn: json['title_en'] as String? ?? '',
    durationMinutes: json['duration_minutes'] as int,
    exerciseId: json['exercise_id'] as String?,
    soundId: json['sound_id'] as String?,
    prompt: json['prompt'] as String?,
    promptEn: json['prompt_en'] as String?,
  );

  @override
  List<Object?> get props => [id, type, title, durationMinutes];
}

class Routine extends Equatable {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String context;
  final String contextEn;
  final List<RoutineStep> steps;
  final bool isPremium;

  Routine({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.context,
    required this.contextEn,
    this.steps = const [],
    this.isPremium = false,
  });

  int get totalMinutes => steps.fold(0, (sum, s) => sum + s.durationMinutes);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'title_en': titleEn,
    'description': description,
    'description_en': descriptionEn,
    'context': context,
    'context_en': contextEn,
    'steps': steps.map((s) => s.toJson()).toList(),
    'is_premium': isPremium,
  };

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'] as String,
    title: json['title'] as String,
    titleEn: json['title_en'] as String,
    description: json['description'] as String,
    descriptionEn: json['description_en'] as String,
    context: json['context'] as String,
    contextEn: json['context_en'] as String,
    steps: (json['steps'] as List).map((s) => RoutineStep.fromJson(s as Map<String, dynamic>)).toList(),
    isPremium: json['is_premium'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [id, title, steps, totalMinutes];
}
