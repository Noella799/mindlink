import 'package:flutter/material.dart';

/// Password input with a show / hide button.
/// The visibility flag is a small ValueNotifier, so no setState is needed.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.fieldKey,
    this.helperText,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final Key? fieldKey;
  final String? helperText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String> autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final ValueNotifier<bool> _obscured = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _obscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscured,
      builder: (context, obscured, _) {
        return TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          obscureText: obscured,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helperText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: obscured ? 'Show password' : 'Hide password',
              icon: Icon(obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => _obscured.value = !obscured,
            ),
          ),
        );
      },
    );
  }
}
