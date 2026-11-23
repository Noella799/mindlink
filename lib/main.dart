import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/app.dart';
import 'package:mindlink/core/storage/shared_preferences_provider.dart';
import 'package:mindlink/features/auth/data/firebase_auth_repository.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/check_in/data/firestore_check_in_repository.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';
import 'package:mindlink/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connects to the Firebase project chosen in `flutterfire configure`.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Saved settings (theme, text size...) are loaded before the first frame.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // Real backend instead of the fake in-memory repositories.
        authRepositoryProvider.overrideWithValue(FirebaseAuthRepository()),
        checkInRepositoryProvider.overrideWithValue(FirestoreCheckInRepository()),
      ],
      child: const MindLinkApp(),
    ),
  );
}