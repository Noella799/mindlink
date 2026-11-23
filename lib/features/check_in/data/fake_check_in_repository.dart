import 'dart:async';

import 'package:mindlink/core/errors/app_exception.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_repository.dart';

/// In-memory check-ins for frontend development and widget tests.
/// Replaced by the Firestore repository at integration.
class FakeCheckInRepository implements CheckInRepository {
  FakeCheckInRepository({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;
  final List<CheckIn> _items = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _nextId = 1;

  @override
  Stream<List<CheckIn>> watchCheckIns(String userId) async* {
    yield _forUser(userId);
    yield* _changes.stream.map((_) => _forUser(userId));
  }

  @override
  Future<CheckIn> addCheckIn(CheckIn checkIn) async {
    await _wait();
    final saved = checkIn.copyWith(id: 'check-in-${_nextId++}');
    _items.add(saved);
    _changes.add(null);
    return saved;
  }

  @override
  Future<void> updateCheckIn(CheckIn checkIn) async {
    await _wait();
    final index = _items.indexWhere((item) => item.id == checkIn.id);
    if (index == -1) throw const AppException('That check-in no longer exists.');
    _items[index] = checkIn;
    _changes.add(null);
  }

  @override
  Future<void> deleteCheckIn(String checkInId) async {
    await _wait();
    _items.removeWhere((item) => item.id == checkInId);
    _changes.add(null);
  }

  void dispose() => _changes.close();

  List<CheckIn> _forUser(String userId) {
    final list = _items.where((item) => item.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(list);
  }

  Future<void> _wait() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
  }
}
