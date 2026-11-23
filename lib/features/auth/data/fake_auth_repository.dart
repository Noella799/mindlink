import 'dart:async';

import 'package:mindlink/features/auth/domain/app_user.dart';
import 'package:mindlink/features/auth/domain/auth_exception.dart';
import 'package:mindlink/features/auth/domain/auth_repository.dart';

/// In-memory auth used while the Firebase backend is being built, and in
/// widget tests. Accounts only live until the app is closed.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AppUser? initialUser,
    this.delay = const Duration(milliseconds: 600),
  }) : _current = initialUser;

  /// Simulated network delay, so loading spinners can be seen.
  final Duration delay;

  final StreamController<AppUser?> _controller = StreamController<AppUser?>.broadcast();
  final Map<String, ({String password, AppUser user})> _accounts = {};
  AppUser? _current;

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    await _wait();
    final account = _accounts[_key(email)];
    if (account == null || account.password != password) {
      throw const AuthException('Incorrect email or password.');
    }
    _setUser(account.user);
    return account.user;
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await _wait();
    if (_accounts.containsKey(_key(email))) {
      throw const AuthException('An account already exists for that email.');
    }
    final user = AppUser(
      id: 'user-${_accounts.length + 1}',
      email: email.trim(),
      displayName: name.trim(),
    );
    _accounts[_key(email)] = (password: password, user: user);
    _setUser(user);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    await _wait();
    const user = AppUser(
      id: 'google-user',
      email: 'student@gmail.com',
      displayName: 'Google Student',
      emailVerified: true,
    );
    _setUser(user);
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) => _wait();

  @override
  Future<void> sendEmailVerification() => _wait();

  @override
  Future<void> signOut() async {
    await _wait();
    _setUser(null);
  }
    @override
  Future<void> reloadUser() => _wait();

  void dispose() => _controller.close();

  String _key(String email) => email.trim().toLowerCase();

  void _setUser(AppUser? user) {
    _current = user;
    _controller.add(user);
  }

  Future<void> _wait() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
  }
}
