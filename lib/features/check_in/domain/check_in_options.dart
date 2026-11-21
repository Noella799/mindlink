// Answers available in the daily check-in. Pure Dart: icons and colours
// for these live in the presentation layer (mood_ui.dart).

/// Question 1: "How are you feeling right now?"
enum Mood {
  great('Great'),
  good('Good'),
  okay('Okay'),
  low('Low'),
  stressed('Stressed');

  const Mood(this.label);
  final String label;

  bool get isDifficult => this == Mood.low || this == Mood.stressed;
}

/// Question 2: "What feels strongest today?"
/// Based on the stress sources students named in our interviews.
enum FeelingSource {
  schoolwork('Schoolwork'),
  deadlines('Deadlines'),
  relationships('Friends & relationships'),
  family('Family'),
  money('Money'),
  health('Sleep & health'),
  other('Something else');

  const FeelingSource(this.label);
  final String label;
}

/// Question 3: "What kind of help would you like?"
enum HelpType {
  calmDown('A quick calming activity', 'Breathe & reset for a few minutes'),
  understand('Information about how I feel', 'Short, trusted reading'),
  talk('Someone to talk to', 'Trusted people and counselling'),
  justTracking('Just checking in today', 'Save my mood and carry on');

  const HelpType(this.label, this.description);
  final String label;
  final String description;
}
