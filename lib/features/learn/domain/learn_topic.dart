class LearnTopic {
  const LearnTopic({
    required this.id,
    required this.title,
    required this.summary,
    required this.paragraphs,
    required this.readMinutes,
    this.reference,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> paragraphs;
  final int readMinutes;

  /// Source shown at the bottom of the article.
  final String? reference;
}

abstract class LearnRepository {
  Future<List<LearnTopic>> getTopics();
}
