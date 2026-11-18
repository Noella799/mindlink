import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/utils/date_format.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/check_in/data/fake_check_in_repository.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_repository.dart';
import 'package:mindlink/features/check_in/domain/check_in_stats.dart';

/// Which storage the app uses. Overridden in main.dart with Firestore.
final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  final repository = FakeCheckInRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

/// Current time, injectable so tests can use a fixed date.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Live list of the signed-in user's check-ins (newest first).
final checkInsProvider = StreamProvider<List<CheckIn>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(const <CheckIn>[]);
  return ref.watch(checkInRepositoryProvider).watchCheckIns(user.id);
});

/// Today's most recent check-in, or null. Drives the Home "Today" card.
final todayCheckInProvider = Provider<CheckIn?>((ref) {
  final checkIns = ref.watch(checkInsProvider).valueOrNull ?? const <CheckIn>[];
  final now = ref.watch(clockProvider)();
  for (final checkIn in checkIns) {
    if (isSameDay(checkIn.createdAt, now)) return checkIn;
  }
  return null;
});

/// Weekly count and streak. Drives the Home stats row.
final checkInStatsProvider = Provider<CheckInStats>((ref) {
  final checkIns = ref.watch(checkInsProvider).valueOrNull ?? const <CheckIn>[];
  return CheckInStats.from(checkIns, ref.watch(clockProvider)());
});
