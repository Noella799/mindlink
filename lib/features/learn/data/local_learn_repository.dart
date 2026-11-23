import 'package:mindlink/features/learn/domain/learn_topic.dart';

/// Short articles bundled with the app.
///
/// Before submission: review the wording as a team and make sure each
/// reference matches the sources cited in the report.
class LocalLearnRepository implements LearnRepository {
  const LocalLearnRepository();

  static const List<LearnTopic> _topics = [
    LearnTopic(
      id: 'stress',
      title: 'Understanding stress',
      summary: 'What stress is, and how to notice it early.',
      readMinutes: 2,
      reference: 'World Health Organization, "Stress" (Q&A), 2023.',
      paragraphs: [
        'Stress is how your body and mind react to pressure. A little stress can help you focus before an exam or a deadline.',
        'When stress lasts a long time, it can affect your sleep, your appetite, your mood and how well you concentrate. You might feel tired, irritable or find it hard to switch off.',
        'Noticing the signs early helps. Short breaks, slow breathing, regular sleep, moving your body and talking to someone you trust can all make stress easier to manage.',
      ],
    ),
    LearnTopic(
      id: 'deadlines',
      title: 'Handling deadlines',
      summary: 'Simple ways to make a heavy workload feel lighter.',
      readMinutes: 2,
      paragraphs: [
        'Write down everything you need to do, then pick the one task that is due first. Seeing it all in one place often makes it feel smaller.',
        'Break big assignments into small steps you can finish in 25 to 30 minutes. Take a short break after each step.',
        'If you know you will struggle to finish on time, talk to your lecturer early. Asking for help before the deadline is a sign of good planning, not weakness.',
      ],
    ),
    LearnTopic(
      id: 'sleep',
      title: 'Sleep and your mood',
      summary: 'Why rest matters, especially during exams.',
      readMinutes: 2,
      paragraphs: [
        'Sleep helps your brain store what you studied and manage emotions. Missing sleep can make small problems feel much bigger.',
        'Try to go to bed and wake up at similar times every day. Put your phone away a little before bed and avoid caffeine late in the day.',
        'If worries keep you awake, write them down and let them wait until tomorrow.',
      ],
    ),
    LearnTopic(
      id: 'asking-for-help',
      title: 'When to ask for help',
      summary: 'Signs that it is time to talk to someone.',
      readMinutes: 2,
      reference: 'World Health Organization, "Mental health: strengthening our response", 2022.',
      paragraphs: [
        'Everyone has hard days. It may be time to reach out if difficult feelings last for more than two weeks, or if they make it hard to study, sleep, eat or spend time with others.',
        'You do not need to wait until things feel serious. Talking early to a friend, a mentor or a counsellor can stop problems from growing.',
        'If you ever feel unsafe or think you might hurt yourself, contact emergency services or someone you trust right away. You can find these options in the Support tab.',
      ],
    ),
  ];

  @override
  Future<List<LearnTopic>> getTopics() async => _topics;
}
