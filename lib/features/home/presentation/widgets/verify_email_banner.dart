import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';

/// Reminds new users to verify their email (security feature in the rubric).
class VerifyEmailBanner extends ConsumerWidget {
  const VerifyEmailBanner({super.key, required this.email});

  final String email;

  Future<void> _resend(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(authControllerProvider.notifier).resendVerification();
    if (!context.mounted) return;
    showAppSnackBar(
      context,
      success ? 'Verification email sent to $email.' : 'Could not send the email. Please try again.',
      isError: !success,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isSending = ref.watch(authControllerProvider).isLoading;
    return Card(
      margin: EdgeInsets.zero,
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mark_email_unread_outlined, color: scheme.onTertiaryContainer),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Please verify your email. We sent a link to $email.',
                    style: TextStyle(color: scheme.onTertiaryContainer),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isSending ? null : () => _resend(context, ref),
                child: const Text('Resend email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
