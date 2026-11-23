import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/check_in/data/check_in_mapper.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';

void main() {
  final checkIn = CheckIn(
    id: 'abc',
    userId: 'u1',
    mood: Mood.low,
    source: FeelingSource.deadlines,
    helpType: HelpType.talk,
    note: 'Two exams this week',
    createdAt: DateTime(2026, 11, 18, 9, 30),
  );

  test('toMap uses the ERD field names', () {
    final map = CheckInMapper.toMap(checkIn);
    expect(map.keys, containsAll(['userId', 'mood', 'source', 'helpType', 'note', 'createdAt']));
    expect(map['mood'], 'low');
    expect(map['createdAt'], isA<Timestamp>());
  });

  test('fromMap(toMap(x)) gives back the same check-in', () {
    final back = CheckInMapper.fromMap('abc', CheckInMapper.toMap(checkIn));
    expect(back.userId, 'u1');
    expect(back.mood, Mood.low);
    expect(back.source, FeelingSource.deadlines);
    expect(back.helpType, HelpType.talk);
    expect(back.note, 'Two exams this week');
    expect(back.createdAt, checkIn.createdAt);
  });

  test('bad or missing values fall back to safe defaults', () {
    final back = CheckInMapper.fromMap('x', {'mood': 'purple'});
    expect(back.mood, Mood.okay);
    expect(back.source, FeelingSource.other);
    expect(back.note, '');
  });
    test('loneliness is saved and read back', () {
    final lonely = CheckIn(
      id: 'x',
      userId: 'u1',
      mood: Mood.low,
      source: FeelingSource.loneliness,
      helpType: HelpType.talk,
      createdAt: DateTime(2026, 11, 23),
    );
    final back = CheckInMapper.fromMap('x', CheckInMapper.toMap(lonely));
    expect(back.source, FeelingSource.loneliness);
  });
}