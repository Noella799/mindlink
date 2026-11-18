import 'package:flutter/material.dart';

/// Simple round logo mark. Replace the icon with the Figma logo asset
/// (Image.asset) once it is exported.
class MindlinkLogo extends StatelessWidget {
  const MindlinkLogo({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'MINDLINK logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
        child: Icon(Icons.spa_rounded, size: size * 0.5, color: scheme.primary),
      ),
    );
  }
}
