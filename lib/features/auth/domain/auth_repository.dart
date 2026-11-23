import 'package:mindlink/features/auth/domain/app_user.dart';

/// Contract between the UI and the authentication backend.
///
/// The UI only talks to this interface. During frontend development it is
/// backed by `FakeAuthRepository`; Kenny's `FirebaseAuthRepository` will
/// implement the same methods. Errors must be thrown as `AuthException`.
abstract class AuthRepository {
  /// Emits the current user straight away, then every sign-in / sign-out.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<AppUser> signInWithEmail(String email, String password);

  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> signInWithGoogle();

  Future<void> sendPasswordReset(String email);

  Future<void> sendEmailVerification();

  Future<void> signOut();

   /// Refreshes the user from the server, e.g. after they verify their email.
  Future<void> reloadUser();
}
