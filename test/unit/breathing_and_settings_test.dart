import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/breathe/domain/breathing.dart';
import 'package:mindlink/features/settings/data/settings_repository.dart';
import 'package:mindlink/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BreathPhase.at', () {
    test('follows in 4s, hold 4s, out 6s, then repeats', () {
      expect(BreathPhase.at(0), BreathPhase.inhale);
      expect(BreathPhase.at(3), BreathPhase.inhale);
      expect(BreathPhase.at(4), BreathPhase.hold);
      expect(BreathPhase.at(8), BreathPhase.exhale);
      expect(BreathPhase.at(13), BreathPhase.exhale);
      expect(BreathPhase.at(14), BreathPhase.inhale);
    });
  });

  group('SettingsRepository', () {
    test('returns defaults when nothing is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = SettingsRepository(await SharedPreferences.getInstance());
      final settings = repository.load();

      expect(settings.theme, ThemePreference.system);
      expect(settings.textSize, TextSizePreference.normal);
      expect(settings.breathingMinutes, 3);
      expect(settings.hideMoodOnHome, isFalse);
    });

    test('restores saved values', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = SettingsRepository(await SharedPreferences.getInstance());
      await repository.saveTheme(ThemePreference.dark);
      await repository.saveTextSize(TextSizePreference.large);
      await repository.saveBreathingMinutes(5);
      await repository.saveHideMood(true);

      final restored = repository.load();
      expect(restored.theme, ThemePreference.dark);
      expect(restored.textSize, TextSizePreference.large);
      expect(restored.breathingMinutes, 5);
      expect(restored.hideMoodOnHome, isTrue);
    });

    test('ignores invalid saved values', () async {
      SharedPreferences.setMockInitialValues({
        SettingsRepository.themeKey: 'purple',
        SettingsRepository.breathingMinutesKey: 42,
      });
      final repository = SettingsRepository(await SharedPreferences.getInstance());
      final settings = repository.load();

      expect(settings.theme, ThemePreference.system);
      expect(settings.breathingMinutes, 3);
    });
  });
}
