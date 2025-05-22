// features/auth/presentation/screens/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constantes/auth_string.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';
import '../widgets/terms_check_box.dart';
import 'terms_condition_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  void _navigateToTerms(bool isPrivacyPolicy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsScreen(isPrivacyPolicy: isPrivacyPolicy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Créer un compte'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/logos/leloprof.png', height: 120),
            const SizedBox(height: 30),
            Text(
              'Rejoignez ${AuthStrings.appName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Plateforme de recrutement pour enseignants et établissements',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Image.asset('assets/logos/login.png', height: 24),
              label: Text(
                'Continuer avec Google',
                style: TextStyle(
                  color:
                      _termsAccepted && _privacyAccepted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed:
                  _termsAccepted && _privacyAccepted
                      ? () =>
                          context.read<AuthBloc>().add(GoogleSignInRequested())
                      : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 30),
            TermsCheckbox(
              value: _termsAccepted,
              onChanged: (v) => setState(() => _termsAccepted = v ?? false),
              prefixText: "J'accepte les ",
              linkText: AuthStrings.termsTitle,
              onLinkTap: () => _navigateToTerms(false),
            ),
            TermsCheckbox(
              value: _privacyAccepted,
              onChanged: (v) => setState(() => _privacyAccepted = v ?? false),
              prefixText: "J'accepte la ",
              linkText: AuthStrings.privacyTitle,
              onLinkTap: () => Navigator.of(context),
            ),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Déjà un compte ? Se connecter'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
