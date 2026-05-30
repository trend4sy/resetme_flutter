import 'package:equatable/equatable.dart';

class DailySummary extends Equatable {
  final DateTime date;
  final double avgMood;
  final double avgStress;
  final double? sleepQuality;
  final String dominantCause;

  DailySummary({
    required this.date,
    required this.avgMood,
    required this.avgStress,
    this.sleepQuality,
    this.dominantCause = 'غير معروف',
  });

  @override
  List<Object?> get props => [date, avgMood, avgStress, sleepQuality, dominantCause];
}

class WeeklyAnalysis extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final double avgStress;
  final double avgMood;
  final double? avgSleepQuality;
  final String? strongestPattern;
  final String? strongestPatternEn;
  final String? bestExerciseId;
  final String? bestExerciseName;
  final String? nextWeekSuggestion;
  final String? nextWeekSuggestionEn;
  final List<DailySummary> dailySummaries;
  final bool isPremium;

  WeeklyAnalysis({
    required this.weekStart,
    required this.weekEnd,
    required this.avgStress,
    required this.avgMood,
    this.avgSleepQuality,
    this.strongestPattern,
    this.strongestPatternEn,
    this.bestExerciseId,
    this.bestExerciseName,
    this.nextWeekSuggestion,
    this.nextWeekSuggestionEn,
    this.dailySummaries = const [],
    this.isPremium = false,
  });

  Map<String, dynamic> toJson() => {
    'week_start': weekStart.toIso8601String(),
    'week_end': weekEnd.toIso8601String(),
    'avg_stress': avgStress,
    'avg_mood': avgMood,
    'avg_sleep_quality': avgSleepQuality,
    'strongest_pattern': strongestPattern,
    'best_exercise_id': bestExerciseId,
  };

  factory WeeklyAnalysis.fromJson(Map<String, dynamic> json) => WeeklyAnalysis(
    weekStart: DateTime.parse(json['week_start'] as String),
    weekEnd: DateTime.parse(json['week_end'] as String),
    avgStress: (json['avg_stress'] as num).toDouble(),
    avgMood: (json['avg_mood'] as num).toDouble(),
    avgSleepQuality: (json['avg_sleep_quality'] as num?)?.toDouble(),
    strongestPattern: json['strongest_pattern'] as String?,
    bestExerciseId: json['best_exercise_id'] as String?,
  );

  @override
  List<Object?> get props => [
    weekStart, weekEnd, avgStress, avgMood, avgSleepQuality,
    strongestPattern, bestExerciseId, dailySummaries, isPremium,
  ];
}
