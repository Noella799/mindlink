/// The signed-in student, as the rest of the app sees them.
/// The Firebase repository converts a Firebase `User` into this class.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.emailVerified = false,
  });

  final String id;
  final String email;
  final String displayName;
  final bool emailVerified;

  String get firstName {
    final name = displayName.trim();
    return name.isEmpty ? '' : name.split(' ').first;
  }
}
