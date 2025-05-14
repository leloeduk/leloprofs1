// features/auth/presentation/pages/auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';
import 'singup_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Se connecter avec Google"),
                  onPressed:
                      () =>
                          context.read<AuthBloc>().add(GoogleSignInRequested()),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      ),
                  child: const Text("Pas de compte ? Inscription"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
