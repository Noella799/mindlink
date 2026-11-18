import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/auth/presentation/screens/splash_screen.dart';
import 'package:mindlink/features/auth/presentation/screens/welcome_screen.dart';
import 'package:mindlink/features/shell/presentation/main_shell.dart';

/// First screen of the app. Shows the main app when a user is signed in
/// and the Welcome screen otherwise. Because Firebase remembers the
/// session, a returning user goes straight to Home after a restart.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) => user == null ? const WelcomeScreen() : const MainShell(),
      loading: () => const SplashScreen(),
      error: (_, __) => const WelcomeScreen(),
    );
  }
}
