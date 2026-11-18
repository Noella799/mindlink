import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/domain/check_in_options.dart';
import 'package:mindlink/features/check_in/presentation/mood_ui.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_history_controller.dart';

Future<void> showEditCheckInSheet(BuildContext context, CheckIn checkIn) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => EditCheckInSheet(checkIn: checkIn),
  );
}

/// Bottom sheet for updating a check-in's mood and note.
class EditCheckInSheet extends ConsumerStatefulWidget {
  const EditCheckInSheet({super.key, required this.checkIn});

  final CheckIn checkIn;

  @override
  ConsumerState<EditCheckInSheet> createState() => _EditCheckInSheetState();
}

class _EditCheckInSheetState extends ConsumerState<EditCheckInSheet> {
  late final ValueNotifier<Mood> _mood = ValueNotifier(widget.checkIn.mood);
  late final TextEditingController _note = TextEditingController(text: widget.checkIn.note);

  @override
  void dispose() {
    _mood.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final updated = widget.checkIn.copyWith(mood: _mood.value, note: _note.text.trim());

    final success = await ref.read(checkInHistoryControllerProvider.notifier).updateCheckIn(updated);
    if (!success) return;
    navigator.pop();
    messenger.showSnackBar(const SnackBar(content: Text('Check-in updated')));
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(checkInHistoryControllerProvider).isLoading;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit check-in', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text('Mood', style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            ValueListenableBuilder<Mood>(
              valueListenable: _mood,
              builder: (context, selected, _) => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final mood in Mood.values)
                    ChoiceChip(
                      avatar: Icon(mood.icon, color: mood.color, size: 20),
                      label: Text(mood.label),
                      selected: selected == mood,
                      onSelected: (_) => _mood.value = mood,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              key: const Key('edit-note'),
              controller: _note,
              maxLength: 200,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Private note'),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(label: 'Save changes', isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
