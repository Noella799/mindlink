import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/presentation/mood_ui.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';
import 'package:mindlink/features/settings/presentation/providers/settings_controller.dart';
import 'package:mindlink/features/shell/presentation/nav_provider.dart';

/// Shows today's mood, or invites the user to check in.
/// Updates on its own as soon as a check-in is saved.
class TodayMoodCard extends ConsumerWidget {
  const TodayMoodCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(checkInsProvider).isLoading;
    final today = ref.watch(todayCheckInProvider);
    final hidden = ref.watch(settingsControllerProvider.select((s) => s.hideMoodOnHome));
    void startCheckIn() => ref.read(navControllerProvider.notifier).select(MainTab.checkIn);

    final Widget content;
    if (isLoading) {
      content = const SizedBox(
        key: ValueKey('loading'),
        height: 96,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (hidden) {
      content = const _HiddenMood(key: ValueKey('hidden'));
    } else if (today == null) {
      content = _NoCheckInYet(key: const ValueKey('empty'), onStart: startCheckIn);
    } else {
      content = _TodayMood(key: ValueKey(today.id), checkIn: today, onCheckInAgain: startCheckIn);
    }

    return Card(
      key: const Key('today-mood-card'),
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer, // soft green card, as in Figma
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: content,
        ),
      ),
    );
  }
}

class _NoCheckInYet extends StatelessWidget {
  const _NoCheckInYet({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How are you feeling today?', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'A quick check-in can help you pause and notice what you need.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: onStart,
          child: const Text('Start check-in'),
        ),
      ],
    );
  }
}

class _TodayMood extends StatelessWidget {
  const _TodayMood({super.key, required this.checkIn, required this.onCheckInAgain});

  final CheckIn checkIn;
  final VoidCallback onCheckInAgain;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scheme.primaryContainer,
              child: Icon(checkIn.mood.icon, color: checkIn.mood.color, size: 34),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's mood", style: textTheme.labelLarge),
                  Text(checkIn.mood.label, style: textTheme.headlineSmall),
                  Text(
                    'Mostly about: ${checkIn.source.label.toLowerCase()}',
                    style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: onCheckInAgain, child: const Text('Check in again')),
        ),
      ],
    );
  }
}

class _HiddenMood extends StatelessWidget {
  const _HiddenMood({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(Icons.visibility_off_outlined, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's mood is hidden", style: textTheme.titleMedium),
              Text('You turned on privacy mode in Settings.', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
