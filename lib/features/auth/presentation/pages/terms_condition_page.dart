// features/auth/presentation/screens/terms_screen.dart
import 'package:flutter/material.dart';
import 'package:leloprof/core/constantes/auth_string.dart';

class TermsScreen extends StatelessWidget {
  final bool isPrivacyPolicy;

  const TermsScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPrivacyPolicy ? AuthStrings.privacyTitle : AuthStrings.termsTitle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          isPrivacyPolicy
              ? AuthStrings.privacyContent
              : AuthStrings.termsContent,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
