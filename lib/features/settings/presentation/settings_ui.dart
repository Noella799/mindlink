import 'package:flutter/material.dart';
import 'package:mindlink/features/settings/domain/app_settings.dart';

extension ThemePreferenceUi on ThemePreference {
  ThemeMode get themeMode => switch (this) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      };

  IconData get icon => switch (this) {
        ThemePreference.system => Icons.brightness_auto_outlined,
        ThemePreference.light => Icons.light_mode_outlined,
        ThemePreference.dark => Icons.dark_mode_outlined,
      };
}
