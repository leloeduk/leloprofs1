import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/pages/drawer_page.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';

import '../../../job/presentation/pages/joboffer_page.dart';
import '../../../school/presentation/pages/school_edit.dart';
import '../../../school/presentation/pages/school_page.dart';
import '../../../teacher/presentation/pages/teacher_edit.dart';
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

  final List<Widget> _pages = [
    const JobofferPage(), // Offres d'emploi
    const SchoolsPage(), // Écoles
    const TeachersPage(), // Enseignants
  ];

  final List<String> _titles = ['Offres d\'emploi', 'Écoles', 'Enseignants'];

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final user = authState.userModel;

    return Scaffold(
      drawer: DrawerPage(user: user),
      // appBar: AppBar(
      //   title: Text(
      //     user.email,
      //     style: TextStyle(color: Theme.of(context).colorScheme.primary),
      //   ),
      //   centerTitle: true,
      // ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(context),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Offres'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Écoles'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Enseignants'),
      ],
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget? _buildFAB(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            // TODO: Naviguer vers la page de création d'offre
          },
          tooltip: 'Nouvelle offre',
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            final teacher = context.read()<TeacherBloc>();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(

            //     builder: (_) => const EditTeacherPage(teacher: teacher.),
            //   ),
            // );
          },
          tooltip: 'Nouvel enseignant',
          child: const Icon(Icons.person_add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            // context.read()<SchoolBloc>();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => const EditSchoolPage()),
            // );
          },
          tooltip: 'Nouvelle école',
          child: const Icon(Icons.school),
        );
      default:
        return null;
    }
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
        Navigator.pop(context);
        onTap();
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
      builder: (_) {
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
                  user.role.name,
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
