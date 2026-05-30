import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  final String id;
  final DateTime dateTime;
  final int moodLevel;
  final int stressLevel;
  final int? sleepQuality;
  final String cause;
  final String? note;
  final bool synced;

  MoodEntry({
    required this.id,
    required this.dateTime,
    required this.moodLevel,
    required this.stressLevel,
    this.sleepQuality,
    this.cause = 'غير معروف',
    this.note,
    this.synced = false,
  });

  MoodEntry copyWith({
    String? id,
    DateTime? dateTime,
    int? moodLevel,
    int? stressLevel,
    int? sleepQuality,
    String? cause,
    String? note,
    bool? synced,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      moodLevel: moodLevel ?? this.moodLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      cause: cause ?? this.cause,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_time': dateTime.toIso8601String(),
    'mood_level': moodLevel,
    'stress_level': stressLevel,
    'sleep_quality': sleepQuality,
    'cause': cause,
    'note': note,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    id: json['id'] as String,
    dateTime: DateTime.parse(json['date_time'] as String),
    moodLevel: json['mood_level'] as int,
    stressLevel: json['stress_level'] as int,
    sleepQuality: json['sleep_quality'] as int?,
    cause: json['cause'] as String? ?? 'غير معروف',
    note: json['note'] as String?,
    synced: true,
  );

  @override
  List<Object?> get props => [id, dateTime, moodLevel, stressLevel, sleepQuality, cause, note, synced];
}
