import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/features/settings/data/settings_repository.dart';

import '../helpers/test_app.dart';

/// Opens every screen on a given screen size. Any "RenderFlex overflowed"
/// error makes the test fail, so this guards the rotation / screen-size
/// requirements in the rubric.
Future<void> visitAllScreens(WidgetTester tester) async {
  for (final tab in ['Check-in', 'Support', 'Home']) {
    await tester.tap(find.text(tab).last);
    await tester.pumpAndSettle();
  }

  final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
  for (final route in [AppRoutes.breathe, AppRoutes.learn, AppRoutes.history, AppRoutes.settings]) {
    navigator.pushNamed(route);
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('no overflow on a small 5.5" phone with large text', (tester) async {
    setScreenSize(tester, smallPhonePortrait, pixelRatio: 2);
    await pumpMindLink(
      tester,
      signedInUser: testUser,
      preferences: {SettingsRepository.textSizeKey: 'larger'},
    );
    await visitAllScreens(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no overflow in landscape', (tester) async {
    setScreenSize(tester, phoneLandscape);
    await pumpMindLink(tester, signedInUser: testUser);

    // Landscape uses a side navigation rail instead of the bottom bar.
    expect(find.byType(NavigationRail), findsOneWidget);
    await visitAllScreens(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Welcome screen fits in landscape', (tester) async {
    setScreenSize(tester, phoneLandscape);
    await pumpMindLink(tester);
    expect(find.text('Get started'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
