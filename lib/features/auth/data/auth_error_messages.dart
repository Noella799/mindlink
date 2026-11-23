/// Turns Firebase Auth error codes into short, polite messages.
/// Kept separate from Firebase so it can be unit tested.
String authErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'email-already-in-use':
      return 'An account already exists for that email.';
    case 'weak-password':
      return 'Please choose a stronger password.';
    case 'too-many-requests':
      return 'Too many attempts. Please wait a moment and try again.';
    case 'network-request-failed':
      return 'No internet connection. Please check your connection and try again.';
    case 'popup-closed-by-user':
    case 'web-context-canceled':
    case 'canceled':
      return 'Google sign-in was cancelled.';
    case 'operation-not-allowed':
      return 'This sign-in method is not turned on yet.';
    default:
      return 'Something went wrong. Please try again.';
  }
}