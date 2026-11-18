enum ThemePreference {
  system('System'),
  light('Light'),
  dark('Dark');

  const ThemePreference(this.label);
  final String label;
}

enum TextSizePreference {
  normal('Default', 1.0),
  large('Large', 1.15),
  larger('Larger', 1.3);

  const TextSizePreference(this.label, this.factor);
  final String label;
  final double factor;
}

/// The four preferences saved with SharedPreferences and restored when
/// the app is reopened.
class AppSettings {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.textSize = TextSizePreference.normal,
    this.breathingMinutes = 3,
    this.hideMoodOnHome = false,
  });

  static const List<int> breathingOptions = [3, 5];

  final ThemePreference theme;
  final TextSizePreference textSize;
  final int breathingMinutes;
  final bool hideMoodOnHome;

  AppSettings copyWith({
    ThemePreference? theme,
    TextSizePreference? textSize,
    int? breathingMinutes,
    bool? hideMoodOnHome,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      textSize: textSize ?? this.textSize,
      breathingMinutes: breathingMinutes ?? this.breathingMinutes,
      hideMoodOnHome: hideMoodOnHome ?? this.hideMoodOnHome,
    );
  }
}
