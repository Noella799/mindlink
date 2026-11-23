import 'package:mindlink/features/support/domain/support_contact.dart';

/// Support options bundled with the app, so they work even offline.
///
/// Numbers checked against official sources (November 2026):
/// - 112: national emergency number (gov.rw/emergency)
/// - 912: toll-free ambulance (Rwanda Biomedical Centre)
/// - 114: Rwanda Biomedical Centre toll-free health call centre
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
      id: 'campus-wellness',
      name: 'ALU Wellness Center (Student Life)',
      description: 'Confidential support from the campus wellness team. '
          'Contact them through Student Life or the student portal.',
      category: SupportCategory.counselling,
      suggestedMessage: "Hi, I'm an ALU student and I'd like to book a confidential "
          'session with the wellness team. When are you available?',
    ),
    SupportContact(
      id: 'rbc-call-centre',
      name: 'Rwanda Biomedical Centre call centre',
      description: 'Free national health call centre. They can direct you to health services near you.',
      category: SupportCategory.counselling,
      phone: '114',
    ),
    SupportContact(
      id: 'emergency',
      name: 'Emergency services',
      description: 'Call now if you or someone else is in immediate danger.',
      category: SupportCategory.urgent,
      phone: '112',
    ),
    SupportContact(
      id: 'ambulance',
      name: 'Ambulance',
      description: 'Free ambulance line for medical emergencies.',
      category: SupportCategory.urgent,
      phone: '912',
    ),
  ];

  @override
  Future<List<SupportContact>> getContacts() async => _contacts;
}
