import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/theme/app_colors.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_form_controller.dart';

/// "03 Check-in" from the Figma prototype: the three questions on one page,
/// answered with chips, then Continue.
class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    try {
      final saved = await ref.read(checkInFormControllerProvider.notifier).submit();
      navigator.pushNamed(AppRoutes.checkInResult, arguments: saved);
    } catch (error) {
      if (!context.mounted) return;
      showAppSnackBar(context, friendlyErrorMessage(error), isError: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(checkInFormControllerProvider);
    final controller = ref.read(checkInFormControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final quiet = textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's check-in"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveBody(
        maxWidth: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                'How are you feeling right now?',
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('There is no right or wrong answer.', style: quiet, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            _ChipGrid(
              columns: 3,
              children: [
                for (final mood in Mood.values)
                  _ChoiceChip(
                    label: mood.label,
                    selected: draft.mood == mood,
                    onTap: () => controller.selectMood(mood),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('What feels strongest today?'),
            _ChipGrid(
              columns: 2,
              children: [
                for (final source in FeelingSource.values)
                  _ChoiceChip(
                    label: source.label,
                    selected: draft.source == source,
                    onTap: () => controller.selectSource(source),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Choose what would help most'),
            for (final help in HelpType.values)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ChoiceChip(
                  label: help.label,
                  selected: draft.helpType == help,
                  onTap: () => controller.selectHelpType(help),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Continue',
              isLoading: draft.isSaving,
              onPressed: draft.isComplete ? () => _submit(context, ref) : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You can change your answers later in My check-ins.',
              style: quiet,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        header: true,
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

/// Lays out chips in a fixed number of equal columns (fewer on very
/// narrow screens). Chips keep their natural height, so big text never overflows.
class _ChipGrid extends StatelessWidget {
  const _ChipGrid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const spacing = AppSpacing.sm;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fit = math.max(1, math.min(columns, (constraints.maxWidth / 110).floor()));
        final width = ((constraints.maxWidth - spacing * (fit - 1)) / fit).floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final child in children) SizedBox(width: width, child: child)],
        );
      },
    );
  }
}

/// Rounded answer button from Figma: white with a light border, or
/// lavender with a purple border when selected.
class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = selected
        ? (isDark ? AppColors.lavenderDark : AppColors.lavender)
        : scheme.surfaceContainerLowest;
    final border = selected ? AppColors.lavenderBorder : scheme.outlineVariant;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: border, width: selected ? 1.5 : 1),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: fill,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: scheme.onSurface,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
