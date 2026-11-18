import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/core/widgets/section_title.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/settings/domain/app_settings.dart';
import 'package:mindlink/features/settings/presentation/providers/settings_controller.dart';
import 'package:mindlink/features/settings/presentation/settings_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign out?',
      message: 'You can sign back in at any time. Your check-ins stay saved.',
      confirmLabel: 'Sign out',
    );
    if (!confirmed) return;
    final success = await ref.read(authControllerProvider.notifier).signOut();
    if (success) navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        showAppSnackBar(context, friendlyErrorMessage(error), isError: true);
      }
    });

    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final user = ref.watch(authStateProvider).valueOrNull;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionTitle('Appearance'),
            _Labelled(
              label: 'Theme',
              child: SegmentedButton<ThemePreference>(
                showSelectedIcon: false,
                segments: [
                  for (final option in ThemePreference.values)
                    ButtonSegment(value: option, icon: Icon(option.icon), label: Text(option.label)),
                ],
                selected: {settings.theme},
                onSelectionChanged: (selection) => controller.setTheme(selection.first),
              ),
            ),
            _Labelled(
              label: 'Text size',
              child: SegmentedButton<TextSizePreference>(
                showSelectedIcon: false,
                segments: [
                  for (final option in TextSizePreference.values)
                    ButtonSegment(value: option, label: Text(option.label)),
                ],
                selected: {settings.textSize},
                onSelectionChanged: (selection) => controller.setTextSize(selection.first),
              ),
            ),
            const SectionTitle('Breathing exercise'),
            _Labelled(
              label: 'Length',
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (final minutes in AppSettings.breathingOptions)
                    ButtonSegment(value: minutes, label: Text('$minutes min')),
                ],
                selected: {settings.breathingMinutes},
                onSelectionChanged: (selection) => controller.setBreathingMinutes(selection.first),
              ),
            ),
            const SectionTitle('Privacy'),
            Card(
              margin: EdgeInsets.zero,
              child: SwitchListTile(
                key: const Key('hide-mood-switch'),
                value: settings.hideMoodOnHome,
                onChanged: controller.setHideMoodOnHome,
                title: const Text('Hide my mood on the Home screen'),
                subtitle: const Text('Useful if other people can see your phone.'),
              ),
            ),
            const SectionTitle('Account'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text(user?.displayName ?? ''),
                    subtitle: Text(user?.email ?? ''),
                    trailing: user == null
                        ? null
                        : Icon(
                            user.emailVerified ? Icons.verified_rounded : Icons.error_outline_rounded,
                            color: user.emailVerified ? scheme.primary : scheme.error,
                            semanticLabel: user.emailVerified ? 'Email verified' : 'Email not verified',
                          ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history_rounded),
                    title: const Text('My check-ins'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.history),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.logout_rounded, color: scheme.error),
                    title: Text('Sign out', style: TextStyle(color: scheme.error)),
                    onTap: () => _signOut(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Settings are saved on this phone and restored when you reopen MINDLINK.',
              style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          // Shrinks the segmented buttons slightly on very narrow screens or
          // with large text, instead of overflowing.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ],
      ),
    );
  }
}
