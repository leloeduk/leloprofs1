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
        if (state is Authenticated) {
          // isNewUser a une valeur par défaut `true` dans UserModel.
          // Le `?? true` est une sécurité supplémentaire si la valeur est null.
          final isNewUser = state.user.isNewUser ?? true;

          if (isNewUser) {
            // Si l'utilisateur est considéré comme nouveau (n'a pas encore finalisé la sélection de rôle),
            // on le dirige vers RoleSelectionPage.
            // RoleSelectionPage est responsable de mettre à jour le rôle et de passer isNewUser à false.
            return const RoleSelectionPage();
          } else {
            // Si l'utilisateur n'est pas nouveau (isNewUser est false),
            // il a déjà configuré son rôle. Il est donc dirigé vers la HomePage.
            // Le contenu de HomePage peut ensuite s'adapter en fonction du state.user.role.
            return const HomePage();
          }
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const SignupPage();
        }
      },
    );
  }
}
