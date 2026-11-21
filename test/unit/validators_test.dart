import 'package:flutter_test/flutter_test.dart';
import 'package:mindlink/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and badly formed emails', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
      expect(Validators.email('aline@'), isNotNull);
      expect(Validators.email('aline@example'), isNotNull);
    });

    test('accepts a normal email, ignoring spaces around it', () {
      expect(Validators.email(' aline@alustudent.com '), isNull);
    });
  });

  group('Validators.newPassword', () {
    test('needs 8+ characters with a letter and a number', () {
      expect(Validators.newPassword(''), 'Please create a password.');
      expect(Validators.newPassword('abc12'), 'Use at least 8 characters.');
      expect(Validators.newPassword('abcdefgh'), 'Use at least one letter and one number.');
      expect(Validators.newPassword('12345678'), 'Use at least one letter and one number.');
      expect(Validators.newPassword('calmMind2026'), isNull);
    });
  });

  test('confirmPassword must match the original', () {
    expect(Validators.confirmPassword('abc', 'abcd'), 'Passwords do not match.');
    expect(Validators.confirmPassword('abcd', 'abcd'), isNull);
  });

  test('name must not be blank', () {
    expect(Validators.name(' '), isNotNull);
    expect(Validators.name('Al'), isNull);
  });
}
