import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../job/presentation/pages/joboffer_page.dart';
import '../../../school/presentation/pages/school_page.dart';
import '../../../teacher/presentation/pages/teacher_page.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

// Importez ici vos pages de tabs

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non authentifié')),
      );
    }
    final user = authState.user;

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          // Récupère le TabController dans le bon contexte
          _tabController = DefaultTabController.of(context);

          return Scaffold(
            drawer: _buildDrawer(context, _tabController!),
            appBar: AppBar(
              title: const Text('Accueil'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed:
                      () => context.read<AuthBloc>().add(SignOutRequested()),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person), text: 'Enseignants'),
                  Tab(icon: Icon(Icons.school), text: 'Écoles'),
                  Tab(icon: Icon(Icons.work), text: 'Offres'),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        'Bienvenue, ${user.displayName ?? 'Utilisateur'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text('Email: ${user.email ?? 'Non renseigné'}'),
                      Text('UID: ${user.uid ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      if (user.photoURL != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: TabBarView(
                    children: [TeachersPage(), SchoolsPage(), JobOffersPage()],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, TabController tabController) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Enseignants'),
            onTap: () {
              tabController.animateTo(0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Écoles'),
            onTap: () {
              tabController.animateTo(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Offres d\'emploi'),
            onTap: () {
              tabController.animateTo(2);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
