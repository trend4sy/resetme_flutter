import 'package:equatable/equatable.dart';

enum JournalType { venting, gratitude }

class JournalEntry extends Equatable {
  final String id;
  final DateTime dateTime;
  final JournalType type;
  final String content;
  final bool synced;

  JournalEntry({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.content,
    this.synced = false,
  });

  JournalEntry copyWith({
    String? id,
    DateTime? dateTime,
    JournalType? type,
    String? content,
    bool? synced,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
      content: content ?? this.content,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_time': dateTime.toIso8601String(),
    'type': type.name,
    'content': content,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String,
    dateTime: DateTime.parse(json['date_time'] as String),
    type: JournalType.values.firstWhere((e) => e.name == json['type']),
    content: json['content'] as String,
    synced: true,
  );

  @override
  List<Object?> get props => [id, dateTime, type, content, synced];
}
