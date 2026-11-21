import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/recommendation.dart';
import 'package:mindlink/features/check_in/presentation/mood_ui.dart';
import 'package:mindlink/features/shell/presentation/nav_provider.dart';

/// "Receive suitable support": shown right after a check-in is saved.
class CheckInResultScreen extends ConsumerWidget {
  const CheckInResultScreen({super.key, required this.checkIn});

  final CheckIn checkIn;

  void _goHome(BuildContext context, WidgetRef ref) {
    ref.read(navControllerProvider.notifier).select(MainTab.home);
    Navigator.of(context).pop();
  }

  void _openAction(BuildContext context, WidgetRef ref, SuggestedAction action) {
    final navigator = Navigator.of(context);
    switch (action) {
      case SuggestedAction.breathe:
        navigator.pushReplacementNamed(AppRoutes.breathe);
      case SuggestedAction.learn:
        navigator.pushReplacementNamed(AppRoutes.learn);
      case SuggestedAction.support:
        ref.read(navControllerProvider.notifier).select(MainTab.support);
        navigator.pop();
      case SuggestedAction.none:
        _goHome(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendation = Recommendation.forCheckIn(checkIn);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in saved')),
      body: ResponsiveBody(
        maxWidth: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.md),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(checkIn.mood.icon, size: 56, color: checkIn.mood.color),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(recommendation.title, style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              recommendation.message,
              style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                Chip(avatar: Icon(checkIn.mood.icon, size: 18), label: Text(checkIn.mood.label)),
                Chip(avatar: Icon(checkIn.source.icon, size: 18), label: Text(checkIn.source.label)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            if (recommendation.action != SuggestedAction.none) ...[
              PrimaryButton(
                label: recommendation.action.buttonLabel,
                icon: recommendation.action.icon,
                onPressed: () => _openAction(context, ref, recommendation.action),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            OutlinedButton(
              onPressed: () => _goHome(context, ref),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on SuggestedAction {
  String get buttonLabel => switch (this) {
        SuggestedAction.breathe => 'Start breathing exercise',
        SuggestedAction.learn => 'Read about it',
        SuggestedAction.support => 'Find support',
        SuggestedAction.none => 'Back to Home',
      };

  IconData get icon => switch (this) {
        SuggestedAction.breathe => Icons.air_rounded,
        SuggestedAction.learn => Icons.menu_book_rounded,
        SuggestedAction.support => Icons.support_rounded,
        SuggestedAction.none => Icons.home_rounded,
      };
}
