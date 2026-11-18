import 'package:mindlink/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves and restores user preferences on the device with SharedPreferences.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const String themeKey = 'settings.theme';
  static const String textSizeKey = 'settings.textSize';
  static const String breathingMinutesKey = 'settings.breathingMinutes';
  static const String hideMoodKey = 'settings.hideMoodOnHome';

  /// Reads the saved values. Anything missing or invalid falls back to the default.
  AppSettings load() {
    const defaults = AppSettings();
    final minutes = _prefs.getInt(breathingMinutesKey);

    return AppSettings(
      theme: _enumByName(ThemePreference.values, _prefs.getString(themeKey), defaults.theme),
      textSize: _enumByName(TextSizePreference.values, _prefs.getString(textSizeKey), defaults.textSize),
      breathingMinutes: AppSettings.breathingOptions.contains(minutes) ? minutes! : defaults.breathingMinutes,
      hideMoodOnHome: _prefs.getBool(hideMoodKey) ?? defaults.hideMoodOnHome,
    );
  }

  Future<void> saveTheme(ThemePreference value) => _prefs.setString(themeKey, value.name);

  Future<void> saveTextSize(TextSizePreference value) => _prefs.setString(textSizeKey, value.name);

  Future<void> saveBreathingMinutes(int value) => _prefs.setInt(breathingMinutesKey, value);

  Future<void> saveHideMood(bool value) => _prefs.setBool(hideMoodKey, value);

  static T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}
