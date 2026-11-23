import 'package:flutter/material.dart';

/// Colour palette for MINDLINK, taken from the Figma prototype.
///
/// Every text/background pair below was checked for WCAG AA contrast
/// (at least 4.5:1). If you change a colour, re-check it at
/// https://webaim.org/resources/contrastchecker/
class AppColors {
  AppColors._();

  // Light theme (Figma)
  static const Color primary = Color(0xFF3B6B5B); // deep green, 6.1:1 with white
  static const Color background = Color(0xFFF6F8F7); // page background
  static const Color cardTint = Color(0xFFEDF3F0); // soft green cards (Home hero, Welcome art)
  static const Color greenTint = Color(0xFFE3EFE9); // selected tab in the bottom bar
  static const Color lavender = Color(0xFFE6E0FA); // buttons and selected chips
  static const Color lavenderBorder = Color(0xFF7B6BD1); // outline of selected chips
  static const Color urgentTint = Color(0xFFF8F1DC); // "Need urgent help?" card
  static const Color textPrimary = Color(0xFF1E2A28); // 11.6:1 on lavender
  static const Color textSecondary = Color(0xFF5B6B68); // 5.0:1 on cardTint
  static const Color error = Color(0xFFB3261E); // 6.5:1 with white text

  // Dark theme
  static const Color primaryDark = Color(0xFF8FD3C7); // 10.5:1 on backgroundDark
  static const Color onPrimaryDark = Color(0xFF0F2E29);
  static const Color backgroundDark = Color(0xFF121816);
  static const Color lavenderDark = Color(0xFF3A3458);
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
