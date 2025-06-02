import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
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
          backgroundColor: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Column(
              children: [
                _buildUserHeader(context, user),
                const Divider(height: 1),
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
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      accountEmail: Text(
        user?.email ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 48, color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        image: const DecorationImage(
          image: AssetImage('assets/logos/leloprof.png'),
          fit: BoxFit.contain,
          opacity: 0.1,
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, UserModel? user) {
    final style = TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onBackground,
    );

    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildMenuTile(
            context,
            icon: Icons.verified_sharp,
            label: "Passer à Pro",
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Page Pro à implémenter')),
              );
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.work,
            label: 'Offres',
            onTap: () {
              Navigator.pop(context);
              context.go('/home', extra: {'initialTabIndex': 0});
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.school,
            label: 'Écoles',
            onTap: () {
              Navigator.pop(context);
              context.go('/home', extra: {'initialTabIndex': 1});
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.person,
            label: 'Enseignants',
            onTap: () {
              Navigator.pop(context);
              context.go('/home', extra: {'initialTabIndex': 2});
            },
          ),
          const Divider(),
          _buildMenuTile(
            context,
            icon: Icons.share,
            label: "Partager l'application",
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction de partage à implémenter'),
                ),
              );
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.star_rate,
            label: "Noter l'application",
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction de notation à implémenter'),
                ),
              );
            },
          ),
          const Divider(),
          _buildMenuTile(
            context,
            icon: Icons.feedback_outlined,
            label: 'Suggestions / Commentaires',
            onTap: () {
              // Navigator.pop(context); // Ferme le drawer
              context.pushNamed('suggestion');
            },
          ),
          const SizedBox(height: 20),
          const Divider(),
          _buildMenuTile(
            context,
            icon: Icons.settings,
            label: "Paramètres",
            onTap: () {
              Navigator.pop(context);
              context.go('/settings');
            },
          ),
          const SizedBox(height: 20),
          _buildMenuTile(
            context,
            icon: Icons.logout,
            label: "Déconnexion",
            iconColor: Colors.red,
            labelColor: Colors.red,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? labelColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: labelColor ?? Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _logout(context);
                },
                child: const Text('Déconnexion'),
              ),
            ],
          ),
    );
  }

  void _logout(BuildContext context) async {
    Navigator.pop(context); // Fermer le drawer
    context.read<AuthBloc>().add(SignOutRequested());

    // Écouter le changement d'état et naviguer quand déconnecté
    final bloc = context.read<AuthBloc>();
    await for (final state in bloc.stream) {
      if (state is Unauthenticated) {
        context.go('/');
        break;
      }
    }
  }
}
