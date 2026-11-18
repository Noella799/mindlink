/// Validation rules for the auth forms. They live outside the UI so they
/// can be unit tested and reused on every screen.
class Validators {
  Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _hasLetter = RegExp(r'[A-Za-z]');
  static final RegExp _hasNumber = RegExp(r'\d');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your name.';
    if (text.length < 2) return 'Your name looks too short.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email.';
    if (!_emailPattern.hasMatch(text)) {
      return 'Please enter a valid email, like name@example.com.';
    }
    return null;
  }

  /// Used on the login screen: we only check that something was typed.
  static String? loginPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter your password.';
    return null;
  }

  /// Used when creating an account.
  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Please create a password.';
    if (text.length < 8) return 'Use at least 8 characters.';
    if (!_hasLetter.hasMatch(text) || !_hasNumber.hasMatch(text)) {
      return 'Use at least one letter and one number.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Please confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }
}
