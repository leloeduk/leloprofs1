import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:leloprof/features/auth/presentation/pages/home_page.dart';
import 'package:leloprof/features/auth/presentation/pages/widgets/title_drawer.dart';

import '../../domain/entities/user_model.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserModel? user;
        if (state is Authenticated) {
          user = state.user;
        }

        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: SafeArea(
            child: Column(
              children: [
                _buildUserHeader(context, user),
                _buildMenuItems(context, user),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader(BuildContext context, UserModel? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        user?.name ?? 'Utilisateur',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      accountEmail: Text(
        user?.email ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.grey[300],
        // Essayer de charger l'image de profil si l'URL est disponible
        // Note: UserModel n'a pas de champ profileImageUrl directement,
        // mais TeacherModel et SchoolModel en ont.
        // Pour une solution générique, il faudrait ajouter profileImageUrl à UserModel
        // ou caster l'utilisateur vers son type spécifique si possible.
        // Pour l'instant, on met un placeholder.
        // backgroundImage: user?.profileImageUrl != null && user!.profileImageUrl!.isNotEmpty
        //     ? NetworkImage(user.profileImageUrl!)
        //     : null,
        child: /* user?.profileImageUrl == null || user!.profileImageUrl!.isEmpty ? */
            const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ) /* : null */,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logos/leloprof.png'),
          fit: BoxFit.contain,
          opacity: 0.05,
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, UserModel? user) {
    return Expanded(
      child: Column(
        children: [
          TitleDrawer(
            title: "Passer à Pro",
            iconData: Icons.verified_sharp,
            onTap: () {
              Navigator.pop(context); // Fermer le drawer
              // Naviguer vers la page Pro (à créer)
              // context.go('/pro-features');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Page Pro à implémenter')),
              );
            },
          ),
          TitleDrawer(
            title: 'Offres',
            iconData: Icons.work,
            onTap: () {
              Navigator.pop(context);
              // Assurez-vous que HomePage gère l'affichage des offres
              // ou naviguez vers une page spécifique des offres
              context.go('/home', extra: {'initialTabIndex': 0}); // Exemple
            },
          ),
          TitleDrawer(
            title: 'Écoles',
            iconData: Icons.school,
            onTap: () {
              Navigator.pop(context);
              context.go('/home', extra: {'initialTabIndex': 1}); // Exemple
            },
          ),
          TitleDrawer(
            title: 'Enseignants',
            iconData: Icons.person,
            onTap: () {
              Navigator.pop(context);
              context.go('/home', extra: {'initialTabIndex': 2}); // Exemple
            },
          ),
          const Divider(),
          TitleDrawer(
            title: "Partager l'application",
            iconData: Icons.share,
            onTap: () {
              Navigator.pop(context);
              // Implémenter la logique de partage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction de partage à implémenter'),
                ),
              );
            },
          ),
          TitleDrawer(
            title: "Noter Application",
            iconData: Icons.mark_chat_read_rounded,
            onTap: () {
              Navigator.pop(context);
              // Implémenter la logique de notation (ex: package in_app_review)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction de notation à implémenter'),
                ),
              );
            },
          ),
          const Spacer(),
          TitleDrawer(
            title: "Paramètres",
            iconData: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              context.go('/settings');
            },
          ),
          TitleDrawer(
            title: "Déconnexion",
            iconData: Icons.logout,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    Navigator.pop(context); // Fermer le drawer d'abord
    // Émettre l'événement de déconnexion
    context.read<AuthBloc>().add(SignOutRequested());

    // Attendre un court instant pour permettre au BLoC de traiter l'événement
    await Future.delayed(const Duration(milliseconds: 100));

    // Naviguer vers la page d'accueil avec remplacement pour éviter de revenir en arrière
    context.go('/');
  }
}
