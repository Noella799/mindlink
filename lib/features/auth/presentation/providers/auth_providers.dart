import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/auth/data/fake_auth_repository.dart';
import 'package:mindlink/features/auth/domain/app_user.dart';
import 'package:mindlink/features/auth/domain/auth_repository.dart';

/// Which auth backend the app uses. Overridden in main.dart with the
/// Firebase implementation once it is ready.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = FakeAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

/// The signed-in user, or null when signed out. The whole app reacts to it.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Runs auth actions and exposes loading / error state to the auth screens.
/// Business logic stays here, not in the widgets.
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<bool> signIn(String email, String password) =>
      _run(() => _repository.signInWithEmail(email.trim(), password));

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) =>
      _run(() async {
        await _repository.registerWithEmail(name: name, email: email.trim(), password: password);
        await _repository.sendEmailVerification();
      });

  Future<bool> signInWithGoogle() => _run(_repository.signInWithGoogle);

  Future<bool> sendPasswordReset(String email) =>
      _run(() => _repository.sendPasswordReset(email.trim()));

  Future<bool> resendVerification() => _run(_repository.sendEmailVerification);
    Future<bool> refreshUser() => _run(_repository.reloadUser);

  Future<bool> signOut() => _run(_repository.signOut);

  /// Returns true if the action succeeded.
  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
