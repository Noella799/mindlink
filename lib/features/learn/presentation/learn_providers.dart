import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/learn/data/local_learn_repository.dart';
import 'package:mindlink/features/learn/domain/learn_topic.dart';

final learnRepositoryProvider = Provider<LearnRepository>((ref) => const LocalLearnRepository());

final learnTopicsProvider = FutureProvider<List<LearnTopic>>((ref) {
  return ref.watch(learnRepositoryProvider).getTopics();
});

extension LearnTopicUi on LearnTopic {
  IconData get icon => switch (id) {
        'stress' => Icons.psychology_outlined,
        'deadlines' => Icons.event_note_rounded,
        'sleep' => Icons.bedtime_outlined,
        'asking-for-help' => Icons.volunteer_activism_outlined,
        _ => Icons.article_outlined,
      };
}
