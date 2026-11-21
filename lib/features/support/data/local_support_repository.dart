import 'package:mindlink/features/support/domain/support_contact.dart';

/// Support options bundled with the app, so they work even offline.
///
/// IMPORTANT: check every phone number with the official source before the
/// demo and add the campus counselling contact. These could also be moved
/// into a Firestore `support_contacts` collection later.
class LocalSupportRepository implements SupportRepository {
  const LocalSupportRepository();

  static const List<SupportContact> _contacts = [
    SupportContact(
      id: 'trusted-friend',
      name: 'Message a friend',
      description: 'Reaching out can be as simple as one short message.',
      category: SupportCategory.trusted,
      suggestedMessage: "Hey, I'm having a tough day. Are you free to talk a bit later?",
    ),
    SupportContact(
      id: 'trusted-mentor',
      name: 'Talk to a family member or mentor',
      description: 'Someone older who knows you can help you see things differently.',
      category: SupportCategory.trusted,
      suggestedMessage: 'Hi, could we find some time to talk this week? I would like some advice.',
    ),
    SupportContact(
      id: 'campus-counselling',
      name: 'Campus counselling / wellness team',
      description: 'Book a confidential session with your university counselling team.',
      category: SupportCategory.counselling,
      // TODO: add the verified campus counselling phone number or email.
    ),
    SupportContact(
      id: 'rbc-hotline',
      name: 'Rwanda Biomedical Centre hotline',
      description: 'Free national health information line.',
      category: SupportCategory.counselling,
      phone: '114', // TODO: verify before submission.
    ),
    SupportContact(
      id: 'emergency',
      name: 'Emergency services',
      description: 'Call now if you or someone else is in immediate danger.',
      category: SupportCategory.urgent,
      phone: '112', // TODO: verify before submission.
    ),
  ];

  @override
  Future<List<SupportContact>> getContacts() async => _contacts;
}
