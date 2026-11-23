import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/primary_button.dart';

/// "01 Welcome" from the Figma prototype. Switches to a side-by-side
/// layout in landscape so nothing overflows.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final quiet = textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    const brand = _BrandHeader();
    const art = _WelcomeArt();

    final intro = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A calmer space for your day',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Check in, learn simple ways to manage stress, and find the right support when you need it.',
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
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          child: const Text('I already have an account'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Your private space. No judgement.', style: quiet, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text('Not a diagnosis or emergency service.', style: quiet, textAlign: TextAlign.center),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight && constraints.maxWidth >= 560;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: landscape ? 900 : 480),
                  child: landscape
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: art),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  brand,
                                  const SizedBox(height: AppSpacing.lg),
                                  intro,
                                  const SizedBox(height: AppSpacing.lg),
                                  actions,
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            brand,
                            const SizedBox(height: AppSpacing.xl),
                            art,
                            const SizedBox(height: AppSpacing.xl),
                            intro,
                            const SizedBox(height: AppSpacing.xxl),
                            actions,
                          ],
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

/// "M" badge with the app name, top-left of the Welcome screen.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'M',
            style: textTheme.titleMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MINDLINK', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('student well-being', style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}

/// Soft green card with a heart in a circle, as in Figma.
class _WelcomeArt extends StatelessWidget {
  const _WelcomeArt();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: 'MINDLINK heart illustration',
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(color: scheme.surfaceContainerLowest, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
            child: Icon(Icons.favorite_rounded, color: scheme.onPrimary, size: 30),
          ),
        ),
      ),
    );
  }
}
