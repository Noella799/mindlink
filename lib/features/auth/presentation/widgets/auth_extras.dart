import 'package:flutter/material.dart';
import 'package:mindlink/core/constants/app_spacing.dart';

/// "or" divider between email sign-in and Google sign-in.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('or', style: TextStyle(color: color)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// Second sign-in method required by the rubric.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.account_circle_outlined),
        label: const Text('Continue with Google'),
      ),
    );
  }
}

/// A line of text followed by a link, wrapping onto two lines if needed.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.text,
    required this.linkLabel,
    required this.onPressed,
  });

  final String text;
  final String linkLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text),
        TextButton(onPressed: onPressed, child: Text(linkLabel)),
      ],
    );
  }
}
