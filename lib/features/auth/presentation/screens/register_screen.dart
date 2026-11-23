import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/core/constants/app_spacing.dart';
import 'package:mindlink/core/router/app_routes.dart';
import 'package:mindlink/core/utils/error_messages.dart';
import 'package:mindlink/core/utils/validators.dart';
import 'package:mindlink/core/widgets/feedback.dart';
import 'package:mindlink/core/widgets/primary_button.dart';
import 'package:mindlink/core/widgets/responsive_body.dart';
import 'package:mindlink/features/auth/presentation/providers/auth_providers.dart';
import 'package:mindlink/features/auth/presentation/widgets/auth_extras.dart';
import 'package:mindlink/features/auth/presentation/widgets/password_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final email = _emailController.text.trim();

    final success = await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text,
          email: email,
          password: _passwordController.text,
        );

    if (!success) return;
    navigator.popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      SnackBar(content: Text('Account created. We sent a verification link to $email.')),
    );
  }

  Future<void> _signInWithGoogle() async {
    final success = await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (success && mounted) Navigator.of(context).popUntil((route) => route.isFirst);
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
      appBar: AppBar(title: const Text('Create your account')),
      body: ResponsiveBody(
        maxWidth: 480,
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'We only ask for what we need. Your check-ins are private to you.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const Key('register-name'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                  decoration: const InputDecoration(
                    labelText: 'First name or nickname',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: const Key('register-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    errorMaxLines: 2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  fieldKey: const Key('register-password'),
                  controller: _passwordController,
                  label: 'Password',
                  helperText: 'At least 8 characters, with a letter and a number.',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.newPassword,
                ),
                const SizedBox(height: AppSpacing.md),
                PasswordField(
                  fieldKey: const Key('register-confirm'),
                  controller: _confirmController,
                  label: 'Confirm password',
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Create account', isLoading: isLoading, onPressed: _submit),
                const SizedBox(height: AppSpacing.lg),
                const OrDivider(),
                const SizedBox(height: AppSpacing.lg),
                GoogleSignInButton(onPressed: isLoading ? null : _signInWithGoogle),
                const SizedBox(height: AppSpacing.md),
                AuthSwitchLink(
                  text: 'Already have an account?',
                  linkLabel: 'Log in',
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
