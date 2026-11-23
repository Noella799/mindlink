// Answers available in the daily check-in. Pure Dart: icons and colours
// for these live in the presentation layer (mood_ui.dart).

/// Question 1: "How are you feeling right now?"
// The labels are the words from the Figma prototype. The enum names
// (great, good, okay, low, stressed) are what is stored in Firestore and
// checked by the security rules, so they must not change.
enum Mood {
  great('Calm'),
  good('Okay'),
  okay('Meh'),
  low('Worried'),
  stressed('Overwhelmed');

  const Mood(this.label);
  final String label;

  bool get isDifficult => this == Mood.low || this == Mood.stressed;
}

/// Question 2: "What feels strongest today?"
/// Based on the stress sources students named in our interviews.
enum FeelingSource {
  schoolwork('School'),
  health('Sleep'),
  relationships('Relationships'),
  money('Money'),
  deadlines('Deadlines'),
  family('Family'),
  other('Something else');

  const FeelingSource(this.label);
  final String label;
}

/// Question 3: "What kind of help would you like?"
enum HelpType {
  calmDown('A quick activity', 'Breathe & reset for a few minutes'),
  understand('Useful information', 'Short, trusted reading'),
  talk('Talk to someone', 'Trusted people and counselling'),
  justTracking('Just checking in today', 'Save my mood and carry on');

  const HelpType(this.label, this.description);
  final String label;
  final String description;
}
