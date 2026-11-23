import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';

/// Friendly message shown when a list is empty or failed to load.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ResponsiveBody(
      maxWidth: 420,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(icon, size: 56, color: scheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
