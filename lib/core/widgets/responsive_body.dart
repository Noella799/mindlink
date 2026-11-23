import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';

/// Scrollable, centred content column.
///
/// Every screen body goes through this widget so that:
/// * content scrolls instead of overflowing on small phones or in landscape,
/// * content does not stretch too wide on large phones and tablets.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // SafeArea keeps content away from notches when the phone is rotated.
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
