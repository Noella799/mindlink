import 'package:mindlink/core/errors/app_exception.dart';

/// Thrown by an [AuthRepository] with a message that can be shown directly
/// to the user, for example "Incorrect email or password."
class AuthException extends AppException {
  const AuthException(super.message);
}
