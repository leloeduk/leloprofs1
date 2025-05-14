import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Créez votre compte professionnel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildGoogleSignUpButton(context),
            const SizedBox(height: 20),
            _buildLoginRedirect(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        icon: Icon(Icons.login_rounded, size: 60),
        label: const Text(
          "S'inscrire avec Google",
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(GoogleSignInRequested());
        },
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Déjà un compte ?"),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Se connecter"),
        ),
      ],
    );
  }
}
