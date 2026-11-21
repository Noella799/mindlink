import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/mindlink_logo.dart';
import 'package:mindlink/core/widgets/primary_button.dart';

/// Welcome screen from the Figma prototype. Switches to a side-by-side
/// layout in landscape so nothing overflows.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final intro = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MindlinkLogo(size: 96),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'MINDLINK',
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A simple and private space to check in with yourself, calm down and find support.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );

    final actions = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: 'Get started',
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          child: const Text('I already have an account'),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                'Your check-ins stay private to your account.',
                style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight && constraints.maxWidth >= 560;
            final minHeight = (constraints.maxHeight - AppSpacing.lg * 2).clamp(0.0, double.infinity).toDouble();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: landscape ? 900 : 480),
                    child: landscape
                        ? Row(
                            children: [
                              Expanded(child: intro),
                              const SizedBox(width: AppSpacing.xl),
                              Expanded(child: actions),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [intro, const SizedBox(height: AppSpacing.xxl), actions],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
