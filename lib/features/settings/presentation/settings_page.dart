import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart'; // pour logout event
import 'package:leloprof/features/auth/domain/entities/user_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres'), centerTitle: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            // Rediriger vers la page login si déconnecté
            context.go('/login');
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 16,
                    ),
                    child: _buildUserInfoSection(context, user),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: const Text('Modifier le profil'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          if (user.role == 'teacher') {
                            context.go('/edit-teacher', extra: user);
                          } else if (user.role == 'school') {
                            context.go('/edit-school', extra: user);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Les visiteurs ne peuvent pas modifier de profil.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Changer le mot de passe'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.go('/change-password');
                          // Ou afficher un dialog si tu veux
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Page des notifications à implémenter',
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Aide et Support'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Aide et Support'),
                                  content: const Text(
                                    'Contactez support@leloprof.com\nTéléphone: +33 1 23 45 67 89',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Fermer'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('À propos de LeloProf'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'LeloProf',
                            applicationVersion: '1.0.0',
                            applicationLegalese: '© 2024 LeloProf',
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Plateforme de recrutement pour enseignants et établissements.',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Se déconnecter',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Unauthenticated) {
            return Center(
              child: TextButton(
                child: const Text('Vous êtes déconnecté. Se connecter'),
                onPressed: () => context.go('/login'),
              ),
            );
          } else if (state is AuthError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, UserModel user) {
    String? profileImageUrl = user.name;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              (profileImageUrl != null && profileImageUrl.isNotEmpty)
                  ? NetworkImage(profileImageUrl)
                  : null,
          child:
              (profileImageUrl == null || profileImageUrl.isEmpty)
                  ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                  : null,
        ),
        const SizedBox(height: 12),
        Text(
          user.name,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(user.role.toUpperCase()),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.15),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
