import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindlink/core/errors/app_exception.dart';
import 'package:mindlink/features/check_in/data/check_in_mapper.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_repository.dart';

/// Stores check-ins in the Firestore collection `check_ins`.
class FirestoreCheckInRepository implements CheckInRepository {
  FirestoreCheckInRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _checkIns => _firestore.collection('check_ins');

  /// READ: live list for one user, newest first.
  /// Needs the composite index from Step 6 (userId + createdAt).
  @override
  Stream<List<CheckIn>> watchCheckIns(String userId) {
    return _checkIns
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => [
              for (final doc in snapshot.docs) CheckInMapper.fromMap(doc.id, doc.data()),
            ]);
  }

  /// CREATE
  @override
  Future<CheckIn> addCheckIn(CheckIn checkIn) async {
    final doc = _checkIns.doc(); // Firestore creates the id
    await _write(
      () => doc.set(CheckInMapper.toMap(checkIn)),
      'Could not save your check-in. Please try again.',
    );
    return checkIn.copyWith(id: doc.id);
  }

  /// UPDATE: only mood and note can change (the security rules enforce this too).
  @override
  Future<void> updateCheckIn(CheckIn checkIn) {
    return _write(
      () => _checkIns.doc(checkIn.id).update({'mood': checkIn.mood.name, 'note': checkIn.note}),
      'Could not update your check-in. Please try again.',
    );
  }

  /// DELETE
  @override
  Future<void> deleteCheckIn(String checkInId) {
    return _write(
      () => _checkIns.doc(checkInId).delete(),
      'Could not delete your check-in. Please try again.',
    );
  }

  /// Offline, Firestore keeps a write and sends it later, but the Future only
  /// finishes when the server answers. After 8 seconds we stop waiting so the
  /// loading spinner does not run forever; the write still happens later.
  Future<void> _write(Future<void> Function() action, String errorMessage) async {
    try {
      await action().timeout(const Duration(seconds: 8));
    } on TimeoutException {
      return;
    } on FirebaseException {
      throw AppException(errorMessage);
    }
  }
}
