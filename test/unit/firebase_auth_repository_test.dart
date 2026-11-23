import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/auth/data/firebase_auth_repository.dart';

void main() {
  test('registering creates the account and a users document', () async {
    final db = FakeFirebaseFirestore();
    final repository = FirebaseAuthRepository(auth: MockFirebaseAuth(), firestore: db);

    final user = await repository.registerWithEmail(
      name: 'Aline',
      email: 'aline@example.com',
      password: 'calmMind2026',
    );

    expect(user.email, 'aline@example.com');
    final profile = await db.collection('users').doc(user.id).get();
    expect(profile.data()?['name'], 'Aline');
    expect(profile.data()?['email'], 'aline@example.com');
  });

  test('sign in and sign out update the current user', () async {
    final auth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'u1', email: 'kenny@example.com', displayName: 'Kenny'),
    );
    final repository = FirebaseAuthRepository(auth: auth, firestore: FakeFirebaseFirestore());

    final user = await repository.signInWithEmail('kenny@example.com', 'anyPassword1');
    expect(user.id, 'u1');
    expect(repository.currentUser?.displayName, 'Kenny');

    await repository.signOut();
    expect(repository.currentUser, isNull);
  });
}