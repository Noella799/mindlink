import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/router/app_router.dart';
import 'package:mindlink/core/theme/app_theme.dart';
import 'package:mindlink/features/auth/presentation/screens/auth_gate.dart';
import 'package:mindlink/features/settings/presentation/providers/settings_controller.dart';
import 'package:mindlink/features/settings/presentation/settings_ui.dart';

/// Root widget. Theme and text size come from the saved user settings,
/// so changing them in Settings updates the whole app instantly.
class MindLinkApp extends ConsumerWidget {
  const MindLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp(
      title: 'MINDLINK',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.theme.themeMode,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        // Combine the phone's own text size with the in-app preference.
        final systemScale = MediaQuery.textScalerOf(context).scale(1);
        final scale = (systemScale * settings.textSize.factor).clamp(0.8, 2.0).toDouble();
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AuthGate(),
    );
  }
}
