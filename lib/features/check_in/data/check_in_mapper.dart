import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';

/// Converts between a CheckIn and a Firestore document in `check_ins`.
/// Field names match the ERD exactly.
class CheckInMapper {
  CheckInMapper._();

  static Map<String, dynamic> toMap(CheckIn checkIn) => {
        'userId': checkIn.userId,
        'mood': checkIn.mood.name,
        'source': checkIn.source.name,
        'helpType': checkIn.helpType.name,
        'note': checkIn.note,
        'createdAt': Timestamp.fromDate(checkIn.createdAt),
      };

  /// Unknown or missing values fall back to safe defaults instead of crashing.
  static CheckIn fromMap(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return CheckIn(
      id: id,
      userId: data['userId'] as String? ?? '',
      mood: _byName(Mood.values, data['mood'], Mood.okay),
      source: _byName(FeelingSource.values, data['source'], FeelingSource.other),
      helpType: _byName(HelpType.values, data['helpType'], HelpType.justTracking),
      note: data['note'] as String? ?? '',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }

  static T _byName<T extends Enum>(List<T> values, Object? name, T fallback) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}