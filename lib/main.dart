import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/app.dart';
import 'package:mindlink/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(Kenny): initialise Firebase here, for example:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SharedPreferences is loaded once before the app starts, so the saved
  // theme and text size are already applied on the very first frame.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // TODO(Kenny): replace the fake repositories with the Firebase ones:
        // authRepositoryProvider.overrideWithValue(FirebaseAuthRepository()),
        // checkInRepositoryProvider.overrideWithValue(FirestoreCheckInRepository()),
      ],
      child: const MindLinkApp(),
    ),
  );
}
