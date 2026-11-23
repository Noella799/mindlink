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

    // The three Figma steps are always shown.
    expect(find.text('Reset in 5 minutes'), findsOneWidget);
    expect(find.text('Inhale slowly for 4 seconds.'), findsOneWidget);
    expect(find.text('Pause gently for 2 seconds.'), findsOneWidget);
    expect(find.text('Exhale slowly for 6 seconds.'), findsOneWidget);

    // Tap without pumpAndSettle: once the timer runs, settling would skip time.
    await tester.ensureVisible(find.text('Start'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Breathe in'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('4:56 left'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Breathe out'), findsOneWidget);

    await tester.ensureVisible(find.text('Pause timer'));
    await tester.tap(find.text('Pause timer'));
    await tester.pump();
    expect(find.text('Paused'), findsOneWidget);

    // Remove the screen so the timer is cancelled before the test ends.
    await tester.pumpWidget(const SizedBox());
  });
}
