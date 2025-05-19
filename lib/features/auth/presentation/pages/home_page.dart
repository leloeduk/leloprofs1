import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import '../../../job/presentation/pages/joboffer_page.dart';
import '../../../school/presentation/pages/school_page.dart';
import '../../../teacher/presentation/pages/teacher_page.dart';
import '../../domain/entities/user_model.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? selectedSchoolId;

  List<Widget> get _pages => [TeachersPage(), SchoolsPage(), JobofferPage()];

  @override
  void initState() {
    final user = context.read<AuthBloc>().state;
    super.initState();
  }

  final List<String> _titles = ['Enseignants', 'Écoles', 'Offres d\'emploi'];

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final user = authState.userModel;

    return Scaffold(
      drawer: _buildDrawer(context, user),
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Enseignants'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Écoles'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Offres'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget? _buildFAB(BuildContext context) {
    if (_currentIndex == 2) {
      // Only show FAB on Job Offers page
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Naviguer vers la page de création d'offre
        },
        tooltip: 'Nouvelle offre',
      );
    }
    return null;
  }

  Drawer _buildDrawer(BuildContext context, UserModel user) {
    return Drawer(
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
                image: AssetImage('assets/images/drawer_bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _createDrawerItem(
                  context,
                  icon: Icons.person,
                  text: 'Profil',
                  onTap: () => _showUserProfile(context, user),
                ),
                _createDrawerItem(
                  context,
                  icon: Icons.settings,
                  text: 'Paramètres',
                  onTap: () {},
                ),
                const Divider(),
                _createDrawerItem(
                  context,
                  icon: Icons.person,
                  text: 'Enseignants',
                  onTap: () => _navigateToPage(0),
                ),
                _createDrawerItem(
                  context,
                  icon: Icons.school,
                  text: 'Écoles',
                  onTap: () => _navigateToPage(1),
                ),
                _createDrawerItem(
                  context,
                  icon: Icons.work,
                  text: 'Offres',
                  onTap: () => _navigateToPage(2),
                ),
                const Divider(),
                _createDrawerItem(
                  context,
                  icon: Icons.help,
                  text: 'Aide',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showUserProfile(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child:
                    user.photoUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? 'Non renseigné',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(user.email),
              const SizedBox(height: 16),
              Chip(
                label: Text(
                  user.role.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      },
    );
  }
}
