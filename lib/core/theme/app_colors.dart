import 'package:flutter/material.dart';

/// Colour palette for MINDLINK.
///
/// Every text/background pair below was checked for WCAG AA contrast
/// (at least 4.5:1). If you change a colour to match Figma, re-check it at
/// https://webaim.org/resources/contrastchecker/
class AppColors {
  AppColors._();

  // Light theme
  static const Color primary = Color(0xFF2F6B63); // 6.2:1 with white text
  static const Color background = Color(0xFFF5F7F6);
  static const Color textPrimary = Color(0xFF1E2A28); // 13.8:1 on background
  static const Color textSecondary = Color(0xFF5B6B68); // 5.2:1 on background
  static const Color error = Color(0xFFB3261E); // 6.5:1 with white text

  // Dark theme
  static const Color primaryDark = Color(0xFF8FD3C7); // 10.5:1 on backgroundDark
  static const Color onPrimaryDark = Color(0xFF0F2E29);
  static const Color backgroundDark = Color(0xFF121816);
  static const Color textPrimaryDark = Color(0xFFE8EEEC); // 15.3:1
  static const Color textSecondaryDark = Color(0xFFA9B7B4); // 8.7:1
  static const Color errorDark = Color(0xFFF2B8B5);
  static const Color onErrorDark = Color(0xFF601410);

  // Mood accents. Used for icons only, never for body text.
  static const Color moodGreat = Color(0xFF2E7D32);
  static const Color moodGood = Color(0xFF558B2F);
  static const Color moodOkay = Color(0xFFB7791F);
  static const Color moodLow = Color(0xFF5C6BC0);
  static const Color moodStressed = Color(0xFFC0504D);
}
