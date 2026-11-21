import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/features/auth/data/auth_error_messages.dart';

void main() {
  test('wrong email or password gives one safe message', () {
    expect(authErrorMessage('wrong-password'), 'Incorrect email or password.');
    expect(authErrorMessage('user-not-found'), 'Incorrect email or password.');
    expect(authErrorMessage('invalid-credential'), 'Incorrect email or password.');
  });

  test('known codes get a specific message', () {
    expect(authErrorMessage('email-already-in-use'), 'An account already exists for that email.');
    expect(authErrorMessage('network-request-failed'), contains('internet'));
    expect(authErrorMessage('popup-closed-by-user'), 'Google sign-in was cancelled.');
  });

  test('unknown codes get a general message', () {
    expect(authErrorMessage('something-new'), 'Something went wrong. Please try again.');
  });
}