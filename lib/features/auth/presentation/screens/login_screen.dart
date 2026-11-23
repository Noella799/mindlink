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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .signIn(_emailController.text, _passwordController.text);

    // The AuthGate underneath now shows Home, so clear the auth screens
    // from the back stack instead of pushing Home on top of them.
    if (success && mounted) Navigator.of(context).popUntil((route) => route.isFirst);
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome back')),
      body: ResponsiveBody(
        maxWidth: 480,
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Log in to continue your daily check-ins.', style: textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const Key('login-email'),
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
                  fieldKey: const Key('login-password'),
                  controller: _passwordController,
                  label: 'Password',
                  validator: Validators.loginPassword,
                  onSubmitted: (_) => _submit(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(label: 'Log in', isLoading: isLoading, onPressed: _submit),
                const SizedBox(height: AppSpacing.lg),
                const OrDivider(),
                const SizedBox(height: AppSpacing.lg),
                GoogleSignInButton(onPressed: isLoading ? null : _signInWithGoogle),
                const SizedBox(height: AppSpacing.md),
                AuthSwitchLink(
                  text: "Don't have an account?",
                  linkLabel: 'Create one',
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
