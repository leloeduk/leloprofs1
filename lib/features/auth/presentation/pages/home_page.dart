// features/auth/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';

import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as Authenticated).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenue, ${user.displayName ?? 'Utilisateur'}'),
      ),
    );
  }
}
