/// An error whose [message] is written for the user and is safe to show
/// in a SnackBar. Repositories should convert Firebase errors into this.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
