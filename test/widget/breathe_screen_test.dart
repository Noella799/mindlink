import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/breathe/presentation/screens/breathe_screen.dart';
import 'package:mindlink/features/settings/data/settings_repository.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('breathing exercise follows the phases and uses the saved length', (tester) async {
    setScreenSize(tester, largePhonePortrait);
    await pumpScreen(
      tester,
      const BreatheScreen(),
      preferences: {SettingsRepository.breathingMinutesKey: 5},
    );

    expect(find.text('Ready when you are'), findsOneWidget);
    expect(find.text('5:00 left'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Breathe in'), findsWidgets);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Hold'), findsOneWidget);
    expect(find.text('4:56 left'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Paused'), findsOneWidget);

    // Remove the screen so the timer is cancelled before the test ends.
    await tester.pumpWidget(const SizedBox());
  });
}
