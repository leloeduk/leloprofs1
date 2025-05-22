import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_state.dart';
import 'home_page.dart';
import 'singup_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state);
        if (state is Authenticated) {
          return const HomePage();
        } else if (state is AuthInitial || state is AuthError) {
          print(state);
          return const SignupPage();
        } else if (state is Unauthenticated) {
          print(state);
          return const SignupPage();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      listener: (context, state) {
        if (state is Unauthenticated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erreur d'authentification ")));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }
}
