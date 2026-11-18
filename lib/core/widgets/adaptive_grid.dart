import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';

/// Lays out [children] in as many columns as fit the available width.
/// One column on a small phone, two or more on large phones and in landscape.
/// Items keep their natural height, so large text never overflows.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.spacing = AppSpacing.md,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = math.max(1, ((maxWidth + spacing) / (minItemWidth + spacing)).floor());
        final itemWidth = ((maxWidth - spacing * (columns - 1)) / columns).floorToDouble();

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
