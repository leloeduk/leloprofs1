import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constantes/auth_string.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';
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
  bool _isSubmitting = false;

  void _navigateToTerms(bool isPrivacyPolicy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsScreen(isPrivacyPolicy: isPrivacyPolicy),
      ),
    );
  }

  void _handleSignIn() {
    if (!_termsAccepted || !_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            "Veuillez accepter les conditions d'utilisation et la politique de confidentialité.",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      );
      return;
    }

    if (_isSubmitting) return;

    context.read<AuthBloc>().add(SignInWithGoogleRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isSubmitting = true);
        } else {
          setState(() => _isSubmitting = false);
        }

        if (state is Authenticated) {
          // Rediriger vers la page de sélection de rôle après connexion
          Navigator.pushReplacementNamed(context, '/role-selection');
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Image.asset('assets/logos/login.png', height: 24),
                  label:
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(
                            'Continuer avec Google',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _termsAccepted && _privacyAccepted
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                  onPressed: _isSubmitting ? null : _handleSignIn,
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
                  onChanged:
                      (v) => setState(() => _privacyAccepted = v ?? false),
                  prefixText: "J'accepte la ",
                  linkText: AuthStrings.privacyTitle,
                  onLinkTap: () => _navigateToTerms(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
