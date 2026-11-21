import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/errors/app_exception.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';

/// Answers given so far in the 3-step check-in.
class CheckInDraft {
  const CheckInDraft({
    this.step = 0,
    this.mood,
    this.source,
    this.helpType,
    this.isSaving = false,
  });

  static const int totalSteps = 3;

  final int step;
  final Mood? mood;
  final FeelingSource? source;
  final HelpType? helpType;
  final bool isSaving;

  bool get isLastStep => step == totalSteps - 1;

  bool get canContinue => switch (step) {
        0 => mood != null,
        1 => source != null,
        _ => helpType != null,
      };

  CheckInDraft copyWith({
    int? step,
    Mood? mood,
    FeelingSource? source,
    HelpType? helpType,
    bool? isSaving,
  }) {
    return CheckInDraft(
      step: step ?? this.step,
      mood: mood ?? this.mood,
      source: source ?? this.source,
      helpType: helpType ?? this.helpType,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Holds the check-in answers and saves them. The screen only calls these
/// methods; it never talks to the repository itself.
class CheckInFormController extends Notifier<CheckInDraft> {
  @override
  CheckInDraft build() => const CheckInDraft();

  void selectMood(Mood mood) => state = state.copyWith(mood: mood);

  void selectSource(FeelingSource source) => state = state.copyWith(source: source);

  void selectHelpType(HelpType helpType) => state = state.copyWith(helpType: helpType);

  void next() {
    if (state.canContinue && !state.isLastStep) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void back() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  void reset() => state = const CheckInDraft();

  /// Creates the check-in (the "C" in CRUD) and resets the form.
  Future<CheckIn> submit({String note = ''}) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      throw const AppException('Please sign in again to save your check-in.');
    }
    final draft = state;
    final mood = draft.mood;
    final source = draft.source;
    final helpType = draft.helpType;
    if (mood == null || source == null || helpType == null) {
      throw const AppException('Please answer all three questions first.');
    }

    state = draft.copyWith(isSaving: true);
    try {
      final saved = await ref.read(checkInRepositoryProvider).addCheckIn(
            CheckIn(
              id: '',
              userId: user.id,
              mood: mood,
              source: source,
              helpType: helpType,
              note: note.trim(),
              createdAt: ref.read(clockProvider)(),
            ),
          );
      state = const CheckInDraft();
      return saved;
    } catch (_) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }
}

final checkInFormControllerProvider =
    NotifierProvider<CheckInFormController, CheckInDraft>(CheckInFormController.new);
