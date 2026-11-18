import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';

/// Where MINDLINK sends the student after a check-in.
enum SuggestedAction { breathe, learn, support, none }

/// "Receive suitable support" step of the check-in user flow.
class Recommendation {
  const Recommendation({required this.title, required this.message, required this.action});

  final String title;
  final String message;
  final SuggestedAction action;

  factory Recommendation.forCheckIn(CheckIn checkIn) {
    final opener = checkIn.mood.isDifficult ? 'It is okay to feel this way. ' : '';

    switch (checkIn.helpType) {
      case HelpType.calmDown:
        return Recommendation(
          title: "Let's slow things down",
          message: '${opener}A few minutes of guided breathing can help your body relax.',
          action: SuggestedAction.breathe,
        );
      case HelpType.understand:
        return Recommendation(
          title: 'Learn a little more',
          message: '${opener}These short reads can help you understand what you are feeling.',
          action: SuggestedAction.learn,
        );
      case HelpType.talk:
        return Recommendation(
          title: "You don't have to do this alone",
          message: '${opener}Choose someone you trust or a counselling option that feels right.',
          action: SuggestedAction.support,
        );
      case HelpType.justTracking:
        if (checkIn.mood.isDifficult) {
          return const Recommendation(
            title: 'Thanks for checking in',
            message: 'It sounds like today is heavy. A short breathing exercise might help.',
            action: SuggestedAction.breathe,
          );
        }
        return const Recommendation(
          title: 'Thanks for checking in',
          message: 'Noticing how you feel is a good habit. See you tomorrow!',
          action: SuggestedAction.none,
        );
    }
  }
}
