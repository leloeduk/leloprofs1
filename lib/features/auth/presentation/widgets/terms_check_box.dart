// features/auth/presentation/widgets/terms_checkbox.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String prefixText;
  final String linkText;
  final VoidCallback onLinkTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.prefixText,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(2),
      checkColor: Colors.red,
      // tileColor: Theme.of(context).colorScheme.primary,
      activeColor: Colors.white,
      checkboxScaleFactor: 1.3,

      dense: true,
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: prefixText),
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onLinkTap,
            ),
          ],
        ),
      ),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
