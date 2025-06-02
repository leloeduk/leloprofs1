import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/pages/drawer_page.dart';
import 'package:leloprof/features/job/presentation/pages/joboffer_page.dart';
import 'package:leloprof/features/school/presentation/pages/school_page.dart';
import 'package:leloprof/features/settings/presentation/settings_page.dart';
import 'package:leloprof/features/teacher/presentation/pages/teacher_page.dart';

import '../../../teacher/presentation/pages/teacher_search_page.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> pages;
  late final List<String> titles;
  late final List<String> images;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    String role = 'visitor';
    if (authState is Authenticated) {
      role = authState.user.role;
    }

    titles = ['Annonces', 'Enseignants', 'Écoles', 'Recherche', 'Paramètres'];
    images = [
      'https://images.unsplash.com/photo-1503676260728-1c00da094a0b', // annonces
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e', // enseignants
      'https://images.unsplash.com/photo-1588072432836-e10032774350', // écoles
      'https://images.unsplash.com/photo-1581090700227-1e8e8f6e62c0', // paramètres
    ];
    pages = [
      JobOfferPage(role: role),
      TeacherPage(role: role),
      SchoolPage(role: role),
      TeacherSearchPage(allTeachers: []),
      // SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      drawer: const DrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            backgroundColor: colorScheme.secondary,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              centerTitle: true,
              title: Text(
                titles[_currentIndex],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black54,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    images[_currentIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade300),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Paramètres',
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          SliverFillRemaining(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child: pages[_currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        backgroundColor: Colors.grey.shade100,
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
            icon: Icon(Icons.search_off_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Recherche',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.settings_outlined),
          //   selectedIcon: Icon(Icons.settings),
          //   label: 'Paramètres',
          // ),
        ],
      ),
    );
  }
}
