import 'package:flutter/material.dart';
import 'package:mindlink/features/breathe/domain/breathing.dart';

/// Circle that grows while breathing in and shrinks while breathing out.
/// Each scale change animates over the length of the current phase.
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
    final scale = !active ? 0.75 : (phase == BreathPhase.exhale ? 0.55 : 1.0);

    return Semantics(
      liveRegion: true,
      label: active ? phase.label : 'Breathing circle',
      child: SizedBox.square(
        dimension: size,
        child: AnimatedScale(
          scale: scale,
          duration: Duration(seconds: active ? phase.seconds : 1),
          curve: Curves.easeInOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [scheme.primary, scheme.primaryContainer],
              ),
              boxShadow: [
                BoxShadow(color: scheme.primaryContainer, blurRadius: 32, spreadRadius: 4),
              ],
            ),
            child: Center(
              child: Icon(Icons.air_rounded, size: size * 0.25, color: scheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
