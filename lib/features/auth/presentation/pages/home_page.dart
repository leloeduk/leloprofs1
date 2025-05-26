import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/pages/drawer_page.dart';
import 'package:leloprof/features/job/presentation/pages/joboffer_page.dart';
import 'package:leloprof/features/school/presentation/pages/school_page.dart';
import 'package:leloprof/features/teacher/presentation/pages/teacher_page.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String role = 'visitor';
    if (authState is Authenticated) {
      role = authState.user.role;
    }

    final List<Widget> pages = [
      JobofferPage(role: role),
      TeacherPage(role: role),
      SchoolPage(role: role),
      Container(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Accueil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      drawer: const DrawerPage(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: Colors.grey.shade200,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Annonces',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Enseignants',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Écoles',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
