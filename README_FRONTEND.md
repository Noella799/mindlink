# MINDLINK – Frontend (Person 1)

Flutter frontend for MINDLINK, ALU Group 24. It runs fully on **fake data** today, so the UI can be built and tested in Chrome before the Firebase backend is ready.

## Run it

```bash
# First time only, if the project has no platform folders yet
flutter create --project-name mindlink --platforms=android,web .

flutter pub get
flutter run -d chrome        # build the UI in Chrome
flutter analyze              # aim for 0 issues (rubric: screenshot this)
flutter test --coverage      # widget + unit tests (rubric: screenshot this)
```

Test in Chrome: create an account on the Register screen (the fake backend keeps it until you close the app), or use **Continue with Google**.

## Folder structure (clean architecture)

```
lib/
  main.dart, app.dart          app start-up, theme, routes
  core/                        shared code used by every feature
    constants/  errors/  router/  storage/  theme/  utils/  widgets/
  features/
    auth/        domain/ data/ presentation/   Welcome, Login, Register, Reset password
    check_in/    domain/ data/ presentation/   3-step check-in, result, history (CRUD)
    home/        domain/ presentation/         Home: today card, stats, quick actions, tip
    breathe/     domain/ presentation/         Breathe & reset animation + timer
    support/     domain/ data/ presentation/   Trusted person, counselling, urgent help
    learn/       domain/ data/ presentation/   Short articles
    settings/    domain/ data/ presentation/   SharedPreferences settings
    shell/       presentation/                 Bottom bar / navigation rail
```

- **domain** – plain Dart classes and rules (no Flutter, no Firebase). Unit tested.
- **data** – where data comes from (fake repositories now, Firebase later).
- **presentation** – screens, widgets and Riverpod providers/controllers.

Widgets never call a repository directly. They call a Riverpod controller, which calls the repository.

## State management: Riverpod

| Provider | What it does |
|---|---|
| `authStateProvider` | Signed-in user; `AuthGate` switches between Welcome and Home |
| `authControllerProvider` | Login, register, Google, reset, sign-out + loading/error |
| `checkInsProvider` | Live list of the user's check-ins (Read) |
| `checkInFormControllerProvider` | The 3 check-in answers + save (Create) |
| `checkInHistoryControllerProvider` | Edit and delete (Update, Delete) |
| `todayCheckInProvider`, `checkInStatsProvider` | Derived values for the Home screen |
| `settingsControllerProvider` | Theme, text size, breathing length, privacy mode |
| `breathingControllerProvider` | Breathing timer |
| `navControllerProvider` | Selected main tab |

**Demo step 5 (state update touching two widgets):** saving a check-in updates the **Today card** and the **stats row** on Home at the same time.

## SharedPreferences (4 settings, restored on relaunch)

`settings.theme`, `settings.textSize`, `settings.breathingMinutes`, `settings.hideMoodOnHome`. They're loaded in `main.dart` before the first frame.

**Demo step 6:** switch to Dark + 5 min, close the app completely, reopen it.

## Responsive layout

- Every screen scrolls instead of overflowing (`ResponsiveBody`).
- Content is limited to 640px wide on big screens.
- Landscape: the bottom bar becomes a side `NavigationRail`, and Welcome and Breathe switch to side-by-side layouts.
- `test/widget/responsive_layout_test.dart` opens every screen on a 5.5" phone with large text and in landscape. Any overflow fails the test.
- Colours meet the 4.5:1 contrast ratio. Buttons are at least 48dp tall.

## For Kenny: plugging in Firebase

1. Add `firebase_core`, `firebase_auth`, `cloud_firestore`, `google_sign_in` to `pubspec.yaml`.
2. Create `features/auth/data/firebase_auth_repository.dart` that `implements AuthRepository`.
   Convert `FirebaseAuthException` codes into `AuthException('friendly message')`.
3. Create `features/check_in/data/firestore_check_in_repository.dart` that `implements CheckInRepository`.
   Use the field names in `features/check_in/domain/check_in.dart` (same as the ERD).
   `watchCheckIns` should use `.snapshots()` so the UI updates instantly.
4. In `main.dart`, call `Firebase.initializeApp(...)` and override the two providers (see TODOs).

No screen code needs to change.

## Before submission

- [ ] Match colours, spacing and icons to the Figma file (`app_colors.dart`, `app_spacing.dart`)
- [ ] Verify phone numbers in `local_support_repository.dart` and add campus counselling contact
- [ ] Check Learn article references match the report's reference list
- [ ] `flutter analyze` → 0 issues, screenshot
- [ ] `flutter test --coverage` → screenshot
