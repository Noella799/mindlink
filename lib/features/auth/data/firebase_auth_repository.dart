import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mindlink/features/auth/data/auth_error_messages.dart';
import 'package:mindlink/features/auth/domain/app_user.dart';
import 'package:mindlink/features/auth/domain/auth_exception.dart';
import 'package:mindlink/features/auth/domain/auth_repository.dart';

/// Real authentication with Firebase Auth.
/// Every new account also gets a document in the `users` collection.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  /// userChanges() also fires when the name or verification status changes.
  /// Firebase remembers the session, so the user stays signed in after a restart.
  @override
  Stream<AppUser?> authStateChanges() => _auth.userChanges().map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Future<AppUser> signInWithEmail(String email, String password) {
    return _guard(() async {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _requireUser(credential.user);
    });
  }

  @override
  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;
      await user.updateDisplayName(name.trim());
      await _saveProfile(user.uid, name: name.trim(), email: email);
      await user.reload();
      return _requireUser(_auth.currentUser);
    });
  }

  @override
  Future<AppUser> signInWithGoogle() {
    return _guard(() async {
      final provider = fb.GoogleAuthProvider();
      // Web opens a popup; Android opens a secure Google sign-in page.
      final credential = kIsWeb
          ? await _auth.signInWithPopup(provider)
          : await _auth.signInWithProvider(provider);
      final user = _requireUser(credential.user);
      await _saveProfile(user.id, name: user.displayName, email: user.email);
      return user;
    });
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (error) {
      // Never reveal whether an account exists for this email.
      if (error.code == 'user-not-found') return;
      throw AuthException(authErrorMessage(error.code));
    }
  }

  @override
  Future<void> sendEmailVerification() {
    return _guard(() async {
      await _auth.currentUser?.sendEmailVerification();
    });
  }

  @override
  Future<void> signOut() => _auth.signOut();

  /// Creates or updates users/{uid}. Only the fields allowed by the security rules.
  Future<void> _saveProfile(String uid, {required String name, required String email}) {
    return _users.doc(uid).set(
      {'name': name, 'email': email, 'createdAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  /// Runs a Firebase call and turns its errors into AuthException messages.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(authErrorMessage(error.code));
    } on FirebaseException {
      throw const AuthException('Could not reach the server. Please try again.');
    }
  }

  AppUser _requireUser(fb.User? user) {
    final appUser = _toAppUser(user);
    if (appUser == null) throw const AuthException('Sign-in failed. Please try again.');
    return appUser;
  }

  AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      emailVerified: user.emailVerified,
    );
  }
}
