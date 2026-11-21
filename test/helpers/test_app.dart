import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/app.dart';
import 'package:mindlink/core/router/app_router.dart';
import 'package:mindlink/core/storage/shared_preferences_provider.dart';
import 'package:mindlink/core/theme/app_theme.dart';
import 'package:mindlink/features/auth/data/fake_auth_repository.dart';
import 'package:mindlink/features/auth/domain/app_user.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/check_in/data/fake_check_in_repository.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const testUser = AppUser(
  id: 'test-user',
  email: 'aline@example.com',
  displayName: 'Aline Uwase',
  emailVerified: true,
);

/// Phone sizes used in the tests (logical pixels x device pixel ratio).
const smallPhonePortrait = Size(360 * 2, 640 * 2); // about 5.5 inches
const largePhonePortrait = Size(430 * 3, 932 * 3); // about 6.7 inches
const phoneLandscape = Size(780 * 3, 360 * 3);

void setScreenSize(WidgetTester tester, Size physicalSize, {double pixelRatio = 3}) {
  tester.view.physicalSize = physicalSize;
  tester.view.devicePixelRatio = pixelRatio;
  addTearDown(tester.view.reset);
}

Future<SharedPreferences> mockPreferences([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

/// Pumps the whole app with fake, instant repositories.
Future<void> pumpMindLink(
  WidgetTester tester, {
  AppUser? signedInUser,
  Map<String, Object> preferences = const {},
}) async {
  final prefs = await mockPreferences(preferences);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(initialUser: signedInUser, delay: Duration.zero),
        ),
        checkInRepositoryProvider.overrideWithValue(FakeCheckInRepository(delay: Duration.zero)),
      ],
      child: const MindLinkApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Pumps a single screen inside a MaterialApp, for focused widget tests.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Map<String, Object> preferences = const {},
  List<Override> overrides = const [],
}) async {
  final prefs = await mockPreferences(preferences);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs), ...overrides],
      child: MaterialApp(
        theme: AppTheme.light,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Scrolls a widget into view, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
