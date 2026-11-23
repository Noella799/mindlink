import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets(
    'completing a check-in updates both the Today card and the stats row',
    (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester, signedInUser: testUser);

      final todayCard = find.byKey(const Key('today-mood-card'));
      final weekStat = find.byKey(const Key('stat-week'));
      expect(find.descendant(of: todayCard, matching: find.text('Start check-in')), findsOneWidget);
      expect(find.descendant(of: weekStat, matching: find.text('0')), findsOneWidget);

      // The single-page check-in from Figma: three questions, then Continue.
      await tapVisible(tester, find.text('Start check-in'));
      expect(find.text('How are you feeling right now?'), findsOneWidget);
      await tapVisible(tester, find.text('Okay'));
      await tapVisible(tester, find.text('School'));
      await tapVisible(tester, find.text('Just checking in today'));
      await tapVisible(tester, find.text('Continue'));

      // Result screen
      expect(find.text('Thanks for checking in'), findsOneWidget);
      await tapVisible(tester, find.text('Back to Home'));

      // One state change, two widgets updated.
      expect(find.descendant(of: todayCard, matching: find.text('Okay')), findsOneWidget);
      expect(find.descendant(of: weekStat, matching: find.text('1')), findsOneWidget);
    },
  );

  testWidgets('Continue stays disabled until all three questions are answered', (tester) async {
    setScreenSize(tester, largePhonePortrait);
    await pumpMindLink(tester, signedInUser: testUser);

    await tapVisible(tester, find.text('Start check-in'));
    await tapVisible(tester, find.text('Calm'));

    final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'));
    expect(button.onPressed, isNull);
  });
}
