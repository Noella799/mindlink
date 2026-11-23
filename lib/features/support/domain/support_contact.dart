/// The three support options from the information architecture.
enum SupportCategory {
  trusted('Someone you trust', 'Start with a friend, family member or mentor.'),
  counselling('Counselling support', 'Confidential help from trained people.'),
  urgent('Urgent help', 'If you or someone else is in danger right now.');

  const SupportCategory(this.title, this.description);
  final String title;
  final String description;
}

class SupportContact {
  const SupportContact({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.phone,
    this.suggestedMessage,
  });

  final String id;
  final String name;
  final String description;
  final SupportCategory category;

  /// Number to call, if this option has one.
  final String? phone;

  /// A ready-made message the student can copy and send to a friend.
  final String? suggestedMessage;
}

abstract class SupportRepository {
  Future<List<SupportContact>> getContacts();
}
