import 'package:flutter/material.dart';
import 'package:mindlink/core/theme/app_colors.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';

/// Icons and colours for check-in answers (presentation only).
extension MoodUi on Mood {
  IconData get icon => switch (this) {
        Mood.great => Icons.sentiment_very_satisfied_rounded,
        Mood.good => Icons.sentiment_satisfied_rounded,
        Mood.okay => Icons.sentiment_neutral_rounded,
        Mood.low => Icons.sentiment_dissatisfied_rounded,
        Mood.stressed => Icons.sentiment_very_dissatisfied_rounded,
      };

  Color get color => switch (this) {
        Mood.great => AppColors.moodGreat,
        Mood.good => AppColors.moodGood,
        Mood.okay => AppColors.moodOkay,
        Mood.low => AppColors.moodLow,
        Mood.stressed => AppColors.moodStressed,
      };
}

extension FeelingSourceUi on FeelingSource {
  IconData get icon => switch (this) {
        FeelingSource.schoolwork => Icons.school_rounded,
        FeelingSource.deadlines => Icons.event_busy_rounded,
        FeelingSource.relationships => Icons.people_alt_rounded,
        FeelingSource.family => Icons.family_restroom_rounded,
        FeelingSource.money => Icons.payments_rounded,
        FeelingSource.health => Icons.bedtime_rounded,
        FeelingSource.other => Icons.more_horiz_rounded,
      };
}

extension HelpTypeUi on HelpType {
  IconData get icon => switch (this) {
        HelpType.calmDown => Icons.air_rounded,
        HelpType.understand => Icons.menu_book_rounded,
        HelpType.talk => Icons.forum_rounded,
        HelpType.justTracking => Icons.check_circle_outline_rounded,
      };
}
