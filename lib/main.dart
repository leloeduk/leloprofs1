import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';
import 'package:leloprof/features/job/data/datasources/firebase_joboffer_repos.dart';
import 'package:leloprof/features/job/presentation/bloc/bloc/joboffer_bloc.dart';
import 'package:leloprof/features/school/data/datasources/firebase_school_repos.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/teacher/data/datasources/firebase_teacher_repos.dart';
import 'package:leloprof/config/firebase_options.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'core/services/sharedpreferences/shared_prefs.dart';
import 'core/themes/theme_light.dart';
import 'features/auth/data/datasources/firebase_auth_repos.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _firebaseAuthRepository = FirebaseAuthRepos();
  final _firebaseJobofferRepos = FirebaseJobofferRepos();
  final _firebaseTeacherRepos = FirebaseTeacherRepos();
  final _firebaseSchoolRepos = FirebaseSchoolRepos();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  AuthBloc(_firebaseAuthRepository)
                    ..add(AppStarted()), // Injection de la dépendance
        ),
        BlocProvider(
          create:
              (_) => TeacherBloc(
                teacherRepository: _firebaseTeacherRepos,
              ), // Injection de la dépendance
        ),
        BlocProvider(
          create: (_) => SchoolBloc(schoolRepository: _firebaseSchoolRepos),
        ),
        BlocProvider(
          create: (_) => JobOfferBloc(_firebaseJobofferRepos),

          // Injection de la dépendance
        ),
      ],
      child: MaterialApp.router(
        // debugShowCheckedModeBanner: ,
        theme: lightDatatheme,

        title: 'LeloProf',
        routerConfig: appRouter,
      ),
    );
  }
}
