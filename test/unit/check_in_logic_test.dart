import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';
import 'package:mindlink/features/check_in/domain/check_in_stats.dart';
import 'package:mindlink/features/check_in/domain/recommendation.dart';

CheckIn checkInAt(DateTime date, {Mood mood = Mood.good, HelpType help = HelpType.justTracking}) {
  return CheckIn(
    id: date.toIso8601String(),
    userId: 'u1',
    mood: mood,
    source: FeelingSource.schoolwork,
    helpType: help,
    createdAt: date,
  );
}

void main() {
  // Wednesday 18 November 2026, 10:00
  final now = DateTime(2026, 11, 18, 10);

  group('CheckInStats', () {
    test('counts only check-ins since Monday', () {
      final stats = CheckInStats.from([
        checkInAt(DateTime(2026, 11, 16, 9)), // Monday
        checkInAt(DateTime(2026, 11, 18, 8)), // Today
        checkInAt(DateTime(2026, 11, 15, 20)), // Last Sunday
      ], now);
      expect(stats.thisWeek, 2);
    });

    test('streak counts consecutive days and keeps going before today\'s check-in', () {
      final stats = CheckInStats.from([
        checkInAt(DateTime(2026, 11, 17, 9)),
        checkInAt(DateTime(2026, 11, 16, 9)),
        checkInAt(DateTime(2026, 11, 14, 9)), // gap on the 15th
      ], now);
      expect(stats.streakDays, 2);
    });

    test('no check-ins means zero', () {
      final stats = CheckInStats.from(const [], now);
      expect(stats.thisWeek, 0);
      expect(stats.streakDays, 0);
    });
  });

  group('Recommendation', () {
    test('calming help leads to the breathing exercise', () {
      final rec = Recommendation.forCheckIn(checkInAt(now, help: HelpType.calmDown));
      expect(rec.action, SuggestedAction.breathe);
    });

    test('asking for someone to talk to leads to Support', () {
      final rec = Recommendation.forCheckIn(checkInAt(now, help: HelpType.talk));
      expect(rec.action, SuggestedAction.support);
    });

    test('a stressed mood still gets a gentle suggestion when just tracking', () {
      final rec = Recommendation.forCheckIn(checkInAt(now, mood: Mood.stressed));
      expect(rec.action, SuggestedAction.breathe);
    });

    test('a good mood while just tracking needs no action', () {
      final rec = Recommendation.forCheckIn(checkInAt(now));
      expect(rec.action, SuggestedAction.none);
    });
  });
}
