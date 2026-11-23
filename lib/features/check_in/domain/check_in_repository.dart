import 'package:mindlink/features/check_in/domain/check_in.dart';

/// Contract for storing check-ins (Create, Read, Update, Delete).
///
/// The fake version keeps data in memory; Kenny's Firestore version will
/// implement the same four operations. Errors must be thrown as
/// `AppException` so the UI can show a friendly SnackBar.
abstract class CheckInRepository {
  /// Read: live list for one user, newest first. Emits again after every change,
  /// which is what makes the UI update instantly without a refresh.
  Stream<List<CheckIn>> watchCheckIns(String userId);

  /// Create: saves a new check-in and returns it with its database id.
  Future<CheckIn> addCheckIn(CheckIn checkIn);

  /// Update: replaces mood / note of an existing check-in.
  Future<void> updateCheckIn(CheckIn checkIn);

  /// Delete.
  Future<void> deleteCheckIn(String checkInId);
}
