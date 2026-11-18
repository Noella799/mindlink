import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key, required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: scheme.onSecondaryContainer),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                tip,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
