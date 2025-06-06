import 'package:flutter/material.dart';
import 'package:leloprof/core/constantes/auth_string.dart';

class TermsScreen extends StatelessWidget {
  final bool isPrivacyPolicy;

  const TermsScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    final title =
        isPrivacyPolicy ? AuthStrings.privacyTitle : AuthStrings.termsTitle;
    final content =
        isPrivacyPolicy ? AuthStrings.privacyContent : AuthStrings.termsContent;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
