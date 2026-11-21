import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/check_in/data/firestore_check_in_repository.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';

CheckIn newCheckIn(String userId, DateTime date) => CheckIn(
      id: '',
      userId: userId,
      mood: Mood.good,
      source: FeelingSource.schoolwork,
      helpType: HelpType.justTracking,
      createdAt: date,
    );

void main() {
  late FakeFirebaseFirestore db;
  late FirestoreCheckInRepository repository;

  setUp(() {
    db = FakeFirebaseFirestore();
    repository = FirestoreCheckInRepository(firestore: db);
  });

  test('create, read, update and delete a check-in', () async {
    final saved = await repository.addCheckIn(newCheckIn('u1', DateTime(2026, 11, 18)));
    expect(saved.id, isNotEmpty);

    var list = await repository.watchCheckIns('u1').first;
    expect(list.single.mood, Mood.good);

    await repository.updateCheckIn(saved.copyWith(mood: Mood.great, note: 'Feeling better'));
    list = await repository.watchCheckIns('u1').first;
    expect(list.single.mood, Mood.great);
    expect(list.single.note, 'Feeling better');

    await repository.deleteCheckIn(saved.id);
    list = await repository.watchCheckIns('u1').first;
    expect(list, isEmpty);
  });

  test('a user only sees their own check-ins, newest first', () async {
    await repository.addCheckIn(newCheckIn('u1', DateTime(2026, 11, 16)));
    await repository.addCheckIn(newCheckIn('u1', DateTime(2026, 11, 18)));
    await repository.addCheckIn(newCheckIn('someone-else', DateTime(2026, 11, 17)));

    final list = await repository.watchCheckIns('u1').first;
    expect(list, hasLength(2));
    expect(list.first.createdAt, DateTime(2026, 11, 18));
  });
}