import 'package:mindlink/core/errors/app_exception.dart';

/// Turns any error into a short, polite message for a SnackBar.
String friendlyErrorMessage(Object error) {
  if (error is AppException) return error.message;
  return 'Something went wrong. Please check your connection and try again.';
}
