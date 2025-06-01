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

    final List<String> titles = [
      'Annonces',
      'Enseignants',
      'Écoles',
      'Paramètres',
    ];

    final List<String> images = [
      'https://images.unsplash.com/photo-1503676260728-1c00da094a0b', // announcement
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e', // teacher
      'https://images.unsplash.com/photo-1588072432836-e10032774350', // school
      'https://images.unsplash.com/photo-1581090700227-1e8e8f6e62c0', // settings
    ];

    final List<Widget> pages = [
      JobofferPage(role: role),
      TeacherPage(role: role),
      SchoolPage(role: role),
      Container(), // Paramètres page à personnaliser
    ];

    return Scaffold(
      drawer: const DrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                titles[_currentIndex],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(images[_currentIndex], fit: BoxFit.cover),
                  // Container(color: Colors.grey),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          SliverFillRemaining(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[_currentIndex],
            ),
          ),
        ],
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
