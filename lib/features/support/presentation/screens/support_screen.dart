import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/theme/app_colors.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/widgets/empty_state.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/core/widgets/section_title.dart';
import 'package:mindlink/features/support/domain/support_contact.dart';
import 'package:mindlink/features/support/presentation/support_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Support screen: trusted person, counselling support, urgent help.
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(supportContactsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: contacts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.cloud_off_rounded,
          title: 'Could not load support options',
          message: friendlyErrorMessage(error),
        ),
        data: (items) => ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You do not have to handle everything alone.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose the kind of support that feels right for you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              for (final category in SupportCategory.values) ...[
                SectionTitle(category.title),
                Text(category.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                for (final contact in items.where((c) => c.category == category))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _SupportCard(contact: contact),
                  ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                'MINDLINK provides information and navigation; it does not replace professional care.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.contact});

  final SupportContact contact;

  bool get _isUrgent => contact.category == SupportCategory.urgent;

  IconData get _icon => switch (contact.category) {
        SupportCategory.trusted => Icons.favorite_outline_rounded,
        SupportCategory.counselling => Icons.psychology_alt_outlined,
        SupportCategory.urgent => Icons.emergency_outlined,
      };

  Future<void> _onTap(BuildContext context) async {
    final phone = contact.phone;
    if (phone != null) {
      await _call(context, phone);
    } else if (contact.suggestedMessage != null) {
      await _showMessageSheet(context, contact.suggestedMessage!);
    } else {
      showAppSnackBar(context, 'Contact details will be added soon.');
    }
  }

  Future<void> _call(BuildContext context, String phone) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Call $phone?',
      message: 'This opens your phone app to call ${contact.name}.',
      confirmLabel: 'Call',
    );
    if (!confirmed) return;

    var opened = false;
    try {
      opened = await launchUrl(Uri(scheme: 'tel', path: phone));
    } catch (_) {
      opened = false;
    }
    if (opened || !context.mounted) return;
    await Clipboard.setData(ClipboardData(text: phone));
    if (!context.mounted) return;
    showAppSnackBar(context, "Couldn't open the phone app. Number copied: $phone");
  }

  Future<void> _showMessageSheet(BuildContext context, String message) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Not sure what to say?', style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              const Text('You can copy this message and send it to someone you trust:'),
              const SizedBox(height: AppSpacing.md),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text('"$message"', style: Theme.of(sheetContext).textTheme.bodyLarge),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () async {
                  final navigator = Navigator.of(sheetContext);
                  await Clipboard.setData(ClipboardData(text: message));
                  navigator.pop();
                  if (context.mounted) showAppSnackBar(context, 'Message copied');
                },
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy message'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Figma shows urgent help on a soft cream card.
    final background = _isUrgent ? (isDark ? scheme.errorContainer : AppColors.urgentTint) : null;
    final foreground = _isUrgent ? (isDark ? scheme.onErrorContainer : AppColors.textPrimary) : null;

    return Card(
      margin: EdgeInsets.zero,
      color: background,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        leading: Icon(_icon, color: foreground ?? scheme.primary, size: 30),
        title: Text(contact.name, style: TextStyle(color: foreground, fontWeight: FontWeight.w600)),
        subtitle: Text(contact.description, style: TextStyle(color: foreground)),
        trailing: contact.phone != null
            ? Chip(
                avatar: Icon(Icons.call_rounded, size: 18, color: foreground ?? scheme.primary),
                label: Text(contact.phone!),
              )
            : Icon(Icons.chevron_right_rounded, color: foreground),
        onTap: () => _onTap(context),
      ),
    );
  }
}
