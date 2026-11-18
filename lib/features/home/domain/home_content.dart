/// Greeting based on the time of day, e.g. "Good morning, Aline".
String greetingFor(DateTime now, String firstName) {
  final part = now.hour < 12
      ? 'Good morning'
      : now.hour < 17
          ? 'Good afternoon'
          : 'Good evening';
  return firstName.isEmpty ? part : '$part, $firstName';
}

const List<String> dailyTips = [
  'Break big tasks into small steps. Finishing one small step still counts.',
  'A short walk or stretch between study sessions can help you focus again.',
  'Drinking water and eating regular meals can make stress easier to handle.',
  'Try to sleep and wake up at similar times, even during exams.',
  'Talking to someone you trust can make a problem feel lighter.',
  "It's okay to ask a lecturer for help or more time early, before the deadline.",
  'Put your phone away for the first 30 minutes after you wake up.',
];

/// One tip per day, the same all day long.
String tipFor(DateTime date) {
  final dayOfYear = date.difference(DateTime(date.year)).inDays;
  return dailyTips[dayOfYear % dailyTips.length];
}
