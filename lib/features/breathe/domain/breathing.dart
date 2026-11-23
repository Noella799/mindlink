/// One breathing cycle from the Figma prototype: inhale 4s, pause 2s,
/// exhale 6s. A longer out-breath than in-breath is a common relaxation pattern.
enum BreathPhase {
  inhale('Breathe in', 4, 'Inhale slowly for 4 seconds.'),
  hold('Pause', 2, 'Pause gently for 2 seconds.'),
  exhale('Breathe out', 6, 'Exhale slowly for 6 seconds.');

  const BreathPhase(this.label, this.seconds, this.instruction);

  final String label;
  final int seconds;
  final String instruction;

  static int get cycleSeconds => values.fold(0, (sum, phase) => sum + phase.seconds);

  /// Which phase the user should be in after [elapsedSeconds].
  static BreathPhase at(int elapsedSeconds) {
    var position = elapsedSeconds % cycleSeconds;
    for (final phase in values) {
      if (position < phase.seconds) return phase;
      position -= phase.seconds;
    }
    return inhale;
  }
}

enum BreathingStatus { ready, running, paused, finished }

/// Everything the Breathe & Reset screen needs to draw itself.
class BreathingState {
  const BreathingState({
    required this.totalSeconds,
    this.elapsedSeconds = 0,
    this.status = BreathingStatus.ready,
  });

  final int totalSeconds;
  final int elapsedSeconds;
  final BreathingStatus status;

  BreathPhase get phase => BreathPhase.at(elapsedSeconds);
  int get remainingSeconds => totalSeconds - elapsedSeconds;
  double get progress => totalSeconds == 0 ? 0 : elapsedSeconds / totalSeconds;

  BreathingState copyWith({int? elapsedSeconds, BreathingStatus? status}) {
    return BreathingState(
      totalSeconds: totalSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
    );
  }
}
