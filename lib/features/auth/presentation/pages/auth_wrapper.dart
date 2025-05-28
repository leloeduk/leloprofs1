import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:leloprof/features/auth/presentation/pages/singup_page.dart';
import 'home_page.dart';
import 'role_selection_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        debugPrint('Current Auth State: $state'); // Log d'état

        if (state is Authenticated) {
          debugPrint(
            'User data: ${state.user.toJson()}',
          ); // Log des données utilisateur
          final isNewUser = state.user.isNewUser ?? true;

          if (isNewUser) {
            debugPrint('Redirecting to RoleSelection (new user)');
            return const RoleSelectionPage();
          } else {
            debugPrint('Redirecting to Home (existing user)');
            return const HomePage();
          }
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          debugPrint('Redirecting to Signup (unauthenticated)');
          return const SignupPage();
        }
      },
    );
  }
}
