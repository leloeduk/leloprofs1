import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';
import 'package:leloprof/features/googleads/bloc/ad_bloc.dart';
import 'package:leloprof/features/job/data/datasources/firebase_joboffer_repos.dart';
import 'package:leloprof/features/job/presentation/bloc/bloc/joboffer_bloc.dart';
import 'package:leloprof/features/school/data/datasources/firebase_school_repos.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/teacher/data/datasources/firebase_teacher_repos.dart';
import 'package:leloprof/config/firebase_options.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacherapp/bloc/teacher_application_bloc.dart';
import 'core/services/sharedpreferences/shared_prefs.dart';
import 'core/themes/theme_light.dart';
import 'features/auth/data/datasources/firebase_auth_repos.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await MobileAds.instance.initialize();
    print('AdMob initialized successfully');

    // Configuration test (à supprimer en production)
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: [
          'a63e97ea-004f-44c7-9ec4-6537181c08c0',
        ], // Remplacez par votre ID réel
      ),
    );
  } catch (e) {
    print('Failed to initialize AdMob: $e');
  }

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
        BlocProvider(
          create:
              (_) =>
                  TeacherApplicationBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider(create: (_) => AdBloc()..add(InitializeAdMob())),
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
