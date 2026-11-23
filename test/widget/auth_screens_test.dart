import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  group('Auth screens', () {
    testWidgets('signed-out users see the Welcome screen', (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester);

      expect(find.text('MINDLINK'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
    });

    testWidgets('login shows validation errors for empty fields', (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester);

      await tapVisible(tester, find.text('I already have an account'));
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Log in'));

      expect(find.text('Please enter your email.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('login with an unknown account shows a polite error', (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester);

      await tapVisible(tester, find.text('I already have an account'));
      await tester.enterText(find.byKey(const Key('login-email')), 'nobody@example.com');
      await tester.enterText(find.byKey(const Key('login-password')), 'whatever1');
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Log in'));

      expect(find.text('Incorrect email or password.'), findsOneWidget);
    });

    testWidgets('register rejects a weak password and a mismatched confirmation', (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester);

      await tapVisible(tester, find.text('Get started'));
      await tester.enterText(find.byKey(const Key('register-name')), 'Aline');
      await tester.enterText(find.byKey(const Key('register-email')), 'aline@example');
      await tester.enterText(find.byKey(const Key('register-password')), 'short');
      await tester.enterText(find.byKey(const Key('register-confirm')), 'different');
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Create account'));

      expect(find.text('Please enter a valid email, like name@example.com.'), findsOneWidget);
      expect(find.text('Use at least 8 characters.'), findsOneWidget);
      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('a new user can register and lands on Home', (tester) async {
      setScreenSize(tester, largePhonePortrait);
      await pumpMindLink(tester);

      await tapVisible(tester, find.text('Get started'));
      await tester.enterText(find.byKey(const Key('register-name')), 'Aline');
      await tester.enterText(find.byKey(const Key('register-email')), 'aline@example.com');
      await tester.enterText(find.byKey(const Key('register-password')), 'calmMind2026');
      await tester.enterText(find.byKey(const Key('register-confirm')), 'calmMind2026');
      await tapVisible(tester, find.widgetWithText(FilledButton, 'Create account'));

      expect(find.textContaining('Aline'), findsWidgets);
      expect(find.text('Support that fits your day'), findsOneWidget);
      // New accounts are not verified yet, so the reminder is shown.
      expect(find.textContaining('Please verify your email'), findsOneWidget);
    });
  });
}
