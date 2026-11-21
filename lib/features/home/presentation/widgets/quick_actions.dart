import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/widgets/adaptive_grid.dart';
import 'package:mindlink/features/shell/presentation/nav_provider.dart';

/// Shortcut tiles on Home: Breathe & reset, Learn, Support, History.
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);
    return AdaptiveGrid(
      minItemWidth: 150,
      children: [
        _ActionTile(
          icon: Icons.air_rounded,
          title: 'Breathe & reset',
          subtitle: 'A few calm minutes',
          onTap: () => navigator.pushNamed(AppRoutes.breathe),
        ),
        _ActionTile(
          icon: Icons.menu_book_rounded,
          title: 'Learn',
          subtitle: 'Short, trusted reads',
          onTap: () => navigator.pushNamed(AppRoutes.learn),
        ),
        _ActionTile(
          icon: Icons.support_rounded,
          title: 'Get support',
          subtitle: 'People who can help',
          onTap: () => ref.read(navControllerProvider.notifier).select(MainTab.support),
        ),
        _ActionTile(
          icon: Icons.history_rounded,
          title: 'My check-ins',
          subtitle: 'See and edit past days',
          onTap: () => navigator.pushNamed(AppRoutes.history),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 124),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(icon, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(title, style: textTheme.titleSmall),
                Text(subtitle, style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
