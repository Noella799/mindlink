import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';

/// Main tabs, matching the information architecture: Home, Check-in, Support.
enum MainTab { home, checkIn, support }

/// Selected tab. Kept in a provider (not setState) because other screens
/// change it too, e.g. "Start check-in" on Home or "Find support" after a check-in.
class NavController extends Notifier<MainTab> {
  @override
  MainTab build() {
    // Go back to Home whenever a different user signs in or out.
    ref.watch(authStateProvider.select((state) => state.valueOrNull?.id));
    return MainTab.home;
  }

  void select(MainTab tab) => state = tab;
}

final navControllerProvider = NotifierProvider<NavController, MainTab>(NavController.new);
