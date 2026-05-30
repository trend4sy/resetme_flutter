import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF7F1E8);
  static const Color comfort = Color(0xFF8FAE9B);
  static const Color sleepDark = Color(0xFF1F2A44);
  static const Color alertWarm = Color(0xFFE9B872);
  static const Color textPrimary = Color(0xFF252525);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF81C784);

  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkText = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  static const Color moodCalm = Color(0xFF8FAE9B);
  static const Color moodStressed = Color(0xFFE9B872);
  static const Color moodTired = Color(0xFF6B8FAE);
  static const Color moodSad = Color(0xFF8E8EC5);
  static const Color moodDistracted = Color(0xFFD4A574);
  static const Color moodCantSleep = Color(0xFF1F2A44);

  static Color moodColor(int level) {
    switch (level) {
      case 1: return moodSad;
      case 2: return moodStressed;
      case 3: return moodDistracted;
      case 4: return moodCalm;
      case 5: return moodCalm.withGreen(180);
      default: return moodCalm;
    }
  }

  static Color stressColor(int level) {
    if (level <= 3) return success;
    if (level <= 7) return alertWarm;
    return error;
  }

  static Color sleepColor(int quality) {
    if (quality >= 8) return success;
    if (quality >= 5) return alertWarm;
    return error;
  }
}
