import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/storage/shared_preferences_provider.dart';
import 'package:mindlink/features/settings/data/settings_repository.dart';
import 'package:mindlink/features/settings/domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

/// Current settings. Starts from the saved values, so preferences are
/// restored on every app launch. Each change updates the UI immediately
/// and is saved in the background.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  Future<void> setTheme(ThemePreference value) async {
    state = state.copyWith(theme: value);
    await _repository.saveTheme(value);
  }

  Future<void> setTextSize(TextSizePreference value) async {
    state = state.copyWith(textSize: value);
    await _repository.saveTextSize(value);
  }

  Future<void> setBreathingMinutes(int value) async {
    state = state.copyWith(breathingMinutes: value);
    await _repository.saveBreathingMinutes(value);
  }

  Future<void> setHideMoodOnHome(bool value) async {
    state = state.copyWith(hideMoodOnHome: value);
    await _repository.saveHideMood(value);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
