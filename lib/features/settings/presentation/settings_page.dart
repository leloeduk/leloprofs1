import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Paramètres'),
        title: const Text("data"),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                _buildUserInfoSection(context, user),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Modifier le profil'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Naviguer vers la page d'édition du profil appropriée
                    if (user.role == 'teacher') {
                      // Assurez-vous de passer l'objet TeacherModel complet si nécessaire
                      // Pour l'instant, on suppose que l'ID suffit pour charger sur la page d'édition
                      context.go(
                        '/edit-teacher',
                        extra: user,
                      ); // Ajustez si TeacherEditPage attend TeacherModel
                    } else if (user.role == 'school') {
                      context.go(
                        '/edit-school',
                        extra: user,
                      ); // Ajustez si SchoolEditPage attend SchoolModel
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
                    // Implémenter la logique de changement de mot de passe
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à implémenter'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Naviguer vers la page des paramètres de notification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Page des notifications à implémenter'),
                      ),
                    );
                  },
                ),
                const Divider(),
                // ListTile(
                //   leading: const Icon(Icons.help_outline),
                //   title: const Text('Aide et Support'),
                //    trailing: const Icon(Icons.arrow_forward_ios),
                //   onTap: () {
                //      ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Page d\'aide à implémenter')),
                //     );
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('À propos de LeloProf'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Afficher une boîte de dialogue "À propos"
                    showAboutDialog(
                      context: context,
                      applicationName: 'LeloProf',
                      applicationVersion:
                          '1.0.0', // Récupérez dynamiquement si possible
                      applicationLegalese: '© 2024 LeloProf',
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Plateforme de recrutement pour enseignants et établissements.',
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }
          // Gérer les autres états si nécessaire (ex: non authentifié, chargement)
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, UserModel user) {
    // Ici aussi, pour l'image, il faudrait une URL dans UserModel ou un cast.
    String profileImageUrl = ''; // Placeholder
    // if (user is TeacherModel) profileImageUrl = user.profileImageUrl ?? '';
    // if (user is SchoolModel) profileImageUrl = user.profileImageUrl ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : null,
            child:
                profileImageUrl.isEmpty
                    ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                    : null,
          ),
          const SizedBox(height: 12),
          Text(user.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Chip(
            label: Text(user.role.toUpperCase()),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
