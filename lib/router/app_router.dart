import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/pages/role_selection_page.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart'; // Ajout pour UserModel
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';
import 'package:leloprof/features/job/presentation/pages/joboffer_edit_page.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

import '../features/auth/presentation/pages/auth_wrapper.dart';
import '../features/auth/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/singup_page.dart';
import '../features/auth/presentation/pages/terms_condition_page.dart';
import '../features/job/presentation/pages/joboffer_detail_page.dart.dart';
import '../features/school/presentation/pages/school_detail_page.dart';
import '../features/school/presentation/pages/school_edit_page.dart';
// Importer les nouvelles pages de configuration (vous devrez créer ces fichiers)
import '../features/settings/presentation/settings_page.dart';
import '../features/teacher/presentation/pages/teacher_setup_page.dart';
import '../features/teacher/presentation/pages/teacher_detail_page.dart';
import '../features/school/presentation/pages/school_setup_page.dart';
import '../features/teacher/presentation/pages/teacher_edit_page.dart'; // Exemple

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'auth',
      builder:
          (context, state) =>
              const AuthWrapper(), // Utilise directement ton wrapper
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) {
        final isPrivacyPolicy = state.uri.queryParameters['privacy'] == 'true';
        return TermsScreen(isPrivacyPolicy: isPrivacyPolicy);
      },
    ),
    GoRoute(
      path: '/role',
      name: 'role',
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(), // Tu adapteras selon rôle
    ),

    GoRoute(
      path: '/teacher/:id',
      name: 'teacher-details',
      builder: (context, state) {
        final teacher = state.extra as TeacherModel;
        // Récupère l'ID de l'utilisateur connecté depuis ton service d'authentification
        final currentUserId =
            context
                .read<AuthBloc>()
                .authRepository
                .getCurrentUser()!
                .id; // adapte selon ton code

        return TeacherDetailPage(
          currentUserId: currentUserId,
          teacher: teacher,
        );
      },
    ),

    GoRoute(
      path: '/edit-teacher',
      name: 'edit-teacher',
      builder: (context, state) {
        final teacher = state.extra as TeacherModel;
        return TeacherEditPage(teacher: teacher); // À implémenter
      },
    ),

    GoRoute(
      path: '/teacher-setup',
      name: 'teacher-setup',
      builder: (context, state) {
        final user = state.extra as UserModel;
        return TeacherSetupPage(initialUser: user);
      },
    ),

    // school pages *
    GoRoute(
      path: '/school/:id',
      name: 'school-details',
      builder: (context, state) {
        final school = state.extra as SchoolModel;
        // Récupère l'ID de l'utilisateur connecté depuis ton service d'authentification
        final currentUserId =
            context
                .read<AuthBloc>()
                .authRepository
                .getCurrentUser()!
                .id; // adapte selon ton code

        return SchoolDetailPage(currentUserId: currentUserId, school: school);
      },
    ),
    GoRoute(
      path: '/edit-school',
      name: 'edit-school',
      builder: (context, state) {
        final school = state.extra as SchoolModel;
        return SchoolEditPage(school: school); // À implémenter
      },
    ),
    GoRoute(
      path: '/school-setup',
      name: 'school-setup',
      builder: (context, state) {
        final user = state.extra as UserModel;
        return SchoolSetupPage(initialUser: user);
      },
    ),
    GoRoute(
      path: '/edit-offer',
      name: 'edit-offer',
      builder: (context, state) {
        final offer = state.extra as JobOfferModel;
        return JobofferEditPage(offer: offer); // À implémenter
      },
    ),
    GoRoute(
      path: '/offer-details',
      name: 'offer-details',
      builder: (context, state) {
        final offer = state.extra as JobOfferModel;
        return JobOfferDetailPage(offer: offer);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
