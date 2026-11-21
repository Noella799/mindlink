import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';

/// Update and Delete actions for the history screen.
/// Read comes from `checkInsProvider`, which updates by itself after each change.
class CheckInHistoryController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> updateCheckIn(CheckIn checkIn) =>
      _run(() => ref.read(checkInRepositoryProvider).updateCheckIn(checkIn));

  Future<bool> deleteCheckIn(String id) =>
      _run(() => ref.read(checkInRepositoryProvider).deleteCheckIn(id));

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final checkInHistoryControllerProvider =
    NotifierProvider<CheckInHistoryController, AsyncValue<void>>(CheckInHistoryController.new);
