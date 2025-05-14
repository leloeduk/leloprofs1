import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:leloprof/features/auth/presentation/pages/auth_page.dart';
import 'package:leloprof/features/auth/presentation/pages/home_page.dart';
import 'package:leloprof/firebase_options.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/firebase_auth_repos_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Création de l'instance concrète
  final authRepository = FirebaseAuthRepository();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository), // Injection de la dépendance
      child: MaterialApp(title: 'LeloProf', home: const AuthWrapper()),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomePage();
        } else if (state is AuthInitial || state is AuthError) {
          return const AuthPage();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
