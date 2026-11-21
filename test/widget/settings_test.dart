import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/home/presentation/screens/home_screen.dart';
import 'package:mindlink/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('changing settings saves them with SharedPreferences', (tester) async {
    setScreenSize(tester, largePhonePortrait);
    await pumpMindLink(tester, signedInUser: testUser);

    await tapVisible(tester, find.byTooltip('Settings'));
    await tapVisible(tester, find.text('Dark'));
    await tapVisible(tester, find.text('5 min'));
    await tapVisible(tester, find.byKey(const Key('hide-mood-switch')));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(SettingsRepository.themeKey), 'dark');
    expect(prefs.getInt(SettingsRepository.breathingMinutesKey), 5);
    expect(prefs.getBool(SettingsRepository.hideMoodKey), isTrue);
  });

  testWidgets('saved settings are restored when the app starts again', (tester) async {
    setScreenSize(tester, largePhonePortrait);
    await pumpMindLink(
      tester,
      signedInUser: testUser,
      preferences: {
        SettingsRepository.themeKey: 'dark',
        SettingsRepository.hideMoodKey: true,
        SettingsRepository.breathingMinutesKey: 5,
      },
    );

    final context = tester.element(find.byType(HomeScreen));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(find.text("Today's mood is hidden"), findsOneWidget);
  });
}
