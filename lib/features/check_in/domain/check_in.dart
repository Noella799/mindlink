import 'package:mindlink/features/check_in/domain/check_in_options.dart';

/// One daily check-in saved by a student.
///
/// Kenny: the Firestore model should map to these exact field names
/// (id, userId, mood, source, helpType, note, createdAt) so the ERD,
/// the database and the UI stay consistent.
class CheckIn {
  const CheckIn({
    required this.id,
    required this.userId,
    required this.mood,
    required this.source,
    required this.helpType,
    required this.createdAt,
    this.note = '',
  });

  final String id;
  final String userId;
  final Mood mood;
  final FeelingSource source;
  final HelpType helpType;
  final String note;
  final DateTime createdAt;

  CheckIn copyWith({
    String? id,
    Mood? mood,
    FeelingSource? source,
    HelpType? helpType,
    String? note,
  }) {
    return CheckIn(
      id: id ?? this.id,
      userId: userId,
      mood: mood ?? this.mood,
      source: source ?? this.source,
      helpType: helpType ?? this.helpType,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }
}
