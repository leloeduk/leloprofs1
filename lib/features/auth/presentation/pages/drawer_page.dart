import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:leloprof/features/auth/presentation/pages/home_page.dart';
import 'package:leloprof/features/auth/presentation/pages/widgets/title_drawer.dart';

import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class DrawerPage extends StatefulWidget {
  final UserModel user;
  const DrawerPage({super.key, required this.user});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final user = authState.userModel;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'Utilisateur'),
              accountEmail: Text(user.email),
              currentAccountPicture:
                  user.photoUrl != null
                      ? CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl!),
                      )
                      : const CircleAvatar(child: Icon(Icons.person)),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/logos/leloprof.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
            ),

            const Divider(),
            TitleDrawer(
              title: 'Offres',
              iconData: Icons.work,

              onTap: () => Navigator.of(context).pop(),
            ),
            TitleDrawer(
              title: 'Écoles',
              iconData: Icons.school,

              onTap: () => Navigator.of(context).pop(),
            ),
            TitleDrawer(
              title: 'Enseignants',
              iconData: Icons.person,

              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(),
            TitleDrawer(
              title: 'Aide',
              iconData: Icons.help,

              onTap: () {
                // TODO: Ajouter navigation aide
              },
            ),
            const Divider(),
            TitleDrawer(
              title: "Déconnection",
              iconData: Icons.logout,
              onTap: () async {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            TitleDrawer(
              title: "Déconnection",
              iconData: Icons.logout,
              onTap: () async {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AuthWrapper()));
              },
            ),
            TitleDrawer(
              title: "Déconnection",
              iconData: Icons.logout,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            const Spacer(),
            TitleDrawer(
              title: "Déconnection",
              iconData: Icons.logout,
              onTap: () async {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AuthWrapper()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
