import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? id;
  final String? email;
  final bool isPremium;
  final bool onboardingCompleted;
  final String? primaryGoal;
  final String? worstTime;
  final int dailyCommitmentMinutes;
  final String? topStressCause;
  final String? bedtime;
  final String? preferredStyle;
  final bool darkMode;
  final String language;
  final DateTime? lastCheckinDate;

  UserProfile({
    this.id,
    this.email,
    this.isPremium = false,
    this.onboardingCompleted = false,
    this.primaryGoal,
    this.worstTime,
    this.dailyCommitmentMinutes = 5,
    this.topStressCause,
    this.bedtime,
    this.preferredStyle,
    this.darkMode = false,
    this.language = 'ar',
    this.lastCheckinDate,
  });

  UserProfile copyWith({
    String? id,
    String? email,
    bool? isPremium,
    bool? onboardingCompleted,
    String? primaryGoal,
    String? worstTime,
    int? dailyCommitmentMinutes,
    String? topStressCause,
    String? bedtime,
    String? preferredStyle,
    bool? darkMode,
    String? language,
    DateTime? lastCheckinDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      worstTime: worstTime ?? this.worstTime,
      dailyCommitmentMinutes: dailyCommitmentMinutes ?? this.dailyCommitmentMinutes,
      topStressCause: topStressCause ?? this.topStressCause,
      bedtime: bedtime ?? this.bedtime,
      preferredStyle: preferredStyle ?? this.preferredStyle,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      lastCheckinDate: lastCheckinDate ?? this.lastCheckinDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'is_premium': isPremium,
    'onboarding_completed': onboardingCompleted,
    'primary_goal': primaryGoal,
    'worst_time': worstTime,
    'daily_commitment_minutes': dailyCommitmentMinutes,
    'top_stress_cause': topStressCause,
    'bedtime': bedtime,
    'preferred_style': preferredStyle,
    'dark_mode': darkMode,
    'language': language,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String?,
    email: json['email'] as String?,
    isPremium: json['is_premium'] as bool? ?? false,
    onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
    primaryGoal: json['primary_goal'] as String?,
    worstTime: json['worst_time'] as String?,
    dailyCommitmentMinutes: json['daily_commitment_minutes'] as int? ?? 5,
    topStressCause: json['top_stress_cause'] as String?,
    bedtime: json['bedtime'] as String?,
    preferredStyle: json['preferred_style'] as String?,
    darkMode: json['dark_mode'] as bool? ?? false,
    language: json['language'] as String? ?? 'ar',
  );

  @override
  List<Object?> get props => [id, email, isPremium, onboardingCompleted, language, darkMode];
}
