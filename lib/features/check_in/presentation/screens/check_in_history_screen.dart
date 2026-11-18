import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/utils/date_format.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/empty_state.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/features/check_in/domain/check_in.dart';
import 'package:mindlink/features/check_in/presentation/mood_ui.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_history_controller.dart';
import 'package:mindlink/features/check_in/presentation/providers/check_in_providers.dart';
import 'package:mindlink/features/check_in/presentation/widgets/edit_check_in_sheet.dart';
import 'package:mindlink/features/shell/presentation/nav_provider.dart';

/// Past check-ins: Read (list), Update (tap to edit), Delete (swipe or menu).
class CheckInHistoryScreen extends ConsumerWidget {
  const CheckInHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(checkInHistoryControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        showAppSnackBar(context, friendlyErrorMessage(error), isError: true);
      }
    });
    final checkIns = ref.watch(checkInsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My check-ins')),
      body: checkIns.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.cloud_off_rounded,
          title: 'Could not load your check-ins',
          message: friendlyErrorMessage(error),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.edit_note_rounded,
              title: 'No check-ins yet',
              message: 'Your check-ins will appear here. They are only visible to you.',
              actionLabel: 'Start a check-in',
              onAction: () {
                ref.read(navControllerProvider.notifier).select(MainTab.checkIn);
                Navigator.of(context).pop();
              },
            );
          }
          return SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Text(
                        'Tap a check-in to edit it. Swipe left to delete.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }
                    final checkIn = items[index - 1];
                    return _CheckInTile(key: ValueKey(checkIn.id), checkIn: checkIn);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _TileAction { edit, delete }

class _CheckInTile extends ConsumerWidget {
  const _CheckInTile({super.key, required this.checkIn});

  final CheckIn checkIn;

  Future<bool> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this check-in?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return false;

    final deleted = await ref.read(checkInHistoryControllerProvider.notifier).deleteCheckIn(checkIn.id);
    if (deleted) {
      messenger.showSnackBar(const SnackBar(content: Text('Check-in deleted')));
    }
    return deleted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final details = [
      formatDateTime(checkIn.createdAt),
      if (checkIn.note.isNotEmpty) checkIn.note,
    ].join('\n');

    return Dismissible(
      key: ValueKey('dismiss-${checkIn.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmAndDelete(context, ref),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: scheme.onError),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          leading: Icon(checkIn.mood.icon, color: checkIn.mood.color, size: 32),
          title: Text('${checkIn.mood.label} · ${checkIn.source.label}'),
          subtitle: Text(details, maxLines: 3, overflow: TextOverflow.ellipsis),
          onTap: () => showEditCheckInSheet(context, checkIn),
          trailing: PopupMenuButton<_TileAction>(
            tooltip: 'More options',
            onSelected: (action) {
              switch (action) {
                case _TileAction.edit:
                  showEditCheckInSheet(context, checkIn);
                case _TileAction.delete:
                  _confirmAndDelete(context, ref);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: _TileAction.edit, child: Text('Edit')),
              PopupMenuItem(value: _TileAction.delete, child: Text('Delete')),
            ],
          ),
        ),
      ),
    );
  }
}
