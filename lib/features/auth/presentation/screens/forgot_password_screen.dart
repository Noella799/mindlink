import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/utils/validators.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final email = _emailController.text.trim();

    final success = await ref.read(authControllerProvider.notifier).sendPasswordReset(email);
    if (!success) return;

    navigator.pop();
    // Same message whether or not the account exists, so the screen
    // cannot be used to find out who has an account.
    messenger.showSnackBar(
      SnackBar(content: Text('If an account exists for $email, a reset link is on its way.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        showAppSnackBar(context, friendlyErrorMessage(error), isError: true);
      }
    });
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: ResponsiveBody(
        maxWidth: 480,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Enter the email you signed up with and we'll send you a link to choose a new password.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                key: const Key('reset-email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                onFieldSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  errorMaxLines: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Send reset link', isLoading: isLoading, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
