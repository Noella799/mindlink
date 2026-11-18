import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/breathe/domain/breathing.dart';
import 'package:mindlink/features/settings/presentation/providers/settings_controller.dart';

/// Runs the breathing timer. Its length comes from the user's saved
/// "breathing exercise length" setting. Auto-disposed, so leaving the
/// screen stops the timer.
class BreathingController extends AutoDisposeNotifier<BreathingState> {
  Timer? _timer;

  @override
  BreathingState build() {
    final minutes = ref.watch(settingsControllerProvider.select((s) => s.breathingMinutes));
    ref.onDispose(() => _timer?.cancel());
    return BreathingState(totalSeconds: minutes * 60);
  }

  void start() {
    if (state.status == BreathingStatus.running) return;
    if (state.status == BreathingStatus.finished) {
      state = BreathingState(totalSeconds: state.totalSeconds);
    }
    state = state.copyWith(status: BreathingStatus.running);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    if (state.status == BreathingStatus.running) {
      state = state.copyWith(status: BreathingStatus.paused);
    }
  }

  void _tick() {
    final next = state.elapsedSeconds + 1;
    if (next >= state.totalSeconds) {
      _timer?.cancel();
      state = state.copyWith(elapsedSeconds: state.totalSeconds, status: BreathingStatus.finished);
    } else {
      state = state.copyWith(elapsedSeconds: next);
    }
  }
}

final breathingControllerProvider =
    NotifierProvider.autoDispose<BreathingController, BreathingState>(BreathingController.new);
