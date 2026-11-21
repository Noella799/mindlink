import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';

/// Weekly count and day streak. Saving one check-in updates both this row
/// and the Today card at the same time (one state change, two widgets).
class StatsRow extends ConsumerWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(checkInStatsProvider);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            key: const Key('stat-week'),
            icon: Icons.calendar_today_rounded,
            value: stats.thisWeek,
            label: 'Check-ins this week',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatTile(
            key: const Key('stat-streak'),
            icon: Icons.local_fire_department_rounded,
            value: stats.streakDays,
            label: stats.streakDays == 1 ? 'Day streak' : 'Days streak',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({super.key, required this.icon, required this.value, required this.label});

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Semantics(
          label: '$value $label',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(height: AppSpacing.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Text('$value', key: ValueKey(value), style: textTheme.headlineMedium),
              ),
              Text(label, style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
