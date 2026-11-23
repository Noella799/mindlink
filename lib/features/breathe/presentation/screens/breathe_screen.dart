import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/theme/app_colors.dart';
import 'package:mindlink/core/utils/date_format.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/features/breathe/domain/breathing.dart';
import 'package:mindlink/features/breathe/presentation/providers/breathing_controller.dart';
import 'package:mindlink/features/breathe/presentation/widgets/breathing_circle.dart';

/// "04 Activity – Breathe & reset" from the Figma prototype.
class BreatheScreen extends ConsumerWidget {
  const BreatheScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(breathingControllerProvider);
    final controller = ref.read(breathingControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Breathe & reset'), centerTitle: true),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight;
            final circleSize = ((landscape ? constraints.maxHeight : constraints.maxWidth) * 0.6)
                .clamp(140.0, 260.0)
                .toDouble();

            final circle = BreathingCircle(
              phase: state.phase,
              active: state.status == BreathingStatus.running,
              size: circleSize,
            );
            final controls = _BreathingControls(state: state, controller: controller);

            if (landscape) {
              return Row(
                children: [
                  Expanded(child: Center(child: circle)),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: controls,
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      circle,
                      const SizedBox(height: AppSpacing.xl),
                      controls,
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

class _BreathingControls extends StatelessWidget {
  const _BreathingControls({required this.state, required this.controller});

  final BreathingState state;
  final BreathingController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final finished = state.status == BreathingStatus.finished;
    final running = state.status == BreathingStatus.running;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          finished
              ? 'You took a few minutes for yourself. Notice how your body feels now.'
              : 'Find a comfortable position. Breathe gently and keep your attention on the rhythm.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final phase in BreathPhase.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _StepCard(
              number: phase.index + 1,
              text: phase.instruction,
              current: running && state.phase == phase,
            ),
          ),
        if (state.status != BreathingStatus.ready) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: state.progress, minHeight: 6),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${formatCountdown(state.remainingSeconds)} left',
            textAlign: TextAlign.center,
            style: textTheme.labelLarge,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        ..._buttons(context),
      ],
    );
  }

  String get _title => switch (state.status) {
        BreathingStatus.ready => 'Reset in ${state.totalSeconds ~/ 60} minutes',
        BreathingStatus.paused => 'Paused',
        BreathingStatus.finished => 'Well done',
        BreathingStatus.running => state.phase.label,
      };

  List<Widget> _buttons(BuildContext context) {
    void done() => Navigator.of(context).pop();
    switch (state.status) {
      case BreathingStatus.ready:
        return [PrimaryButton(label: 'Start', icon: Icons.play_arrow_rounded, onPressed: controller.start)];
      case BreathingStatus.running:
        return [
          OutlinedButton.icon(
            onPressed: controller.pause,
            icon: const Icon(Icons.pause_rounded),
            label: const Text('Pause timer'),
          ),
        ];
      case BreathingStatus.paused:
        return [
          PrimaryButton(label: 'Resume', icon: Icons.play_arrow_rounded, onPressed: controller.start),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: done, child: const Text('Done')),
        ];
      case BreathingStatus.finished:
        return [
          PrimaryButton(label: 'Done', onPressed: done),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: controller.start, child: const Text('Do it again')),
        ];
    }
  }
}

/// Numbered step card from Figma. The current step is highlighted while
/// the exercise runs.
class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.text, required this.current});

  final int number;
  final String text;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlight = isDark ? AppColors.lavenderDark : AppColors.lavender;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: current ? highlight : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: current ? AppColors.lavenderBorder : scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Text('$number', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: AppSpacing.lg),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
