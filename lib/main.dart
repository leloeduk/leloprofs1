import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/job/data/datasources/firebase_joboffer_repos.dart';
import 'package:leloprof/features/job/presentation/bloc/bloc/joboffer_bloc.dart';
import 'package:leloprof/features/school/data/datasources/firebase_school_repos.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/teacher/data/datasources/firebase_teacher_repos.dart';
import 'package:leloprof/config/firebase_options.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'features/auth/data/datasources/firebase_auth_repos.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final firebaseAuthRepository = FirebaseAuthRepos();
  final firebaseJobofferRepos = FirebaseJobofferRepos();
  final firebaseTeacherRepos = FirebaseTeacherRepos();
  final firebaseSchollRepos = FirebaseSchoolRepos();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                firebaseAuthRepository,
              ), // Injection de la dépendance
        ),
        BlocProvider(
          create:
              (_) => TeacherBloc(
                teacherRepository: FirebaseTeacherRepos(),
              ), // Injection de la dépendance
        ),
        BlocProvider(
          create: (_) => SchoolBloc(schoolRepository: FirebaseSchoolRepos()),
        ),
        BlocProvider(
          create:
              (_) => JobOfferBloc(
                jobOfferRepository: FirebaseJobofferRepos(),
              ), // Injection de la dépendance
        ),
      ],
      child: MaterialApp(title: 'LeloProf', home: const AuthWrapper()),
    );
  }
}
