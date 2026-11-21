import 'package:mindlink/core/utils/date_format.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';

/// Numbers shown on the Home screen. Calculated here, not in the widget,
/// so the rules can be unit tested.
class CheckInStats {
  const CheckInStats({required this.thisWeek, required this.streakDays});

  /// Check-ins since Monday of the current week.
  final int thisWeek;

  /// Days in a row with at least one check-in. Today still counts as
  /// "in progress", so the streak is not lost before the user checks in.
  final int streakDays;

  factory CheckInStats.from(List<CheckIn> checkIns, DateTime now) {
    final today = startOfDay(now);
    final weekStart = DateTime(today.year, today.month, today.day - (today.weekday - 1));
    final thisWeek = checkIns.where((c) => !c.createdAt.isBefore(weekStart)).length;

    final days = checkIns.map((c) => startOfDay(c.createdAt)).toSet();
    var day = days.contains(today) ? today : DateTime(today.year, today.month, today.day - 1);
    var streak = 0;
    while (days.contains(day)) {
      streak++;
      day = DateTime(day.year, day.month, day.day - 1);
    }

    return CheckInStats(thisWeek: thisWeek, streakDays: streak);
  }
}
