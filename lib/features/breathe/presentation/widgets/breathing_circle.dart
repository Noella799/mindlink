import 'package:flutter/material.dart';
import 'package:mindlink/features/breathe/domain/breathing.dart';

/// Figma's breathing circle: a soft green circle, a white circle inside it
/// and a green dot in the middle. The white circle grows while breathing in
/// and shrinks while breathing out, over the length of each phase.
class BreathingCircle extends StatelessWidget {
  const BreathingCircle({
    super.key,
    required this.phase,
    required this.active,
    required this.size,
  });

  final BreathPhase phase;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scale = !active ? 0.6 : (phase == BreathPhase.exhale ? 0.45 : 0.85);

    return Semantics(
      liveRegion: true,
      label: active ? phase.label : 'Breathing circle',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: scheme.surfaceContainer, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: scale,
          duration: Duration(seconds: active ? phase.seconds : 1),
          curve: Curves.easeInOut,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Container(
                width: size * 0.04,
                height: size * 0.04,
                decoration: BoxDecoration(color: scheme.onPrimary, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
