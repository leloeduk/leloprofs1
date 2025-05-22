import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/auth/presentation/pages/home_page.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_event.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_event.dart';

import '../../../school/domain/models/school_model.dart';

import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class AccountTypePage extends StatelessWidget {
  final User user;

  const AccountTypePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur lors de la création du compte enseignat"),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: AppBar(title: const Text("Choisissez votre profil")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTypeCard(
                    context,
                    title: "Enseignant",
                    icon: Icons.school,
                    type: 'teacher',
                    description: "Rejoignez la communauté des enseignants",
                    ontap: () async {
                      final teacher = TeacherModel(
                        uid: state.userModel.uid,
                        email: state.userModel.email,
                        firstName: state.userModel.displayName!,
                        lastName: "",
                        phoneNumber: "",
                        department: "",
                        createdAt: DateTime.now(),
                      );
                      context.read<TeacherBloc>().add(CreateTeacher(teacher));
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  _buildTypeCard(
                    context,
                    title: "École",
                    icon: Icons.account_balance,
                    type: 'school',
                    description: "Créez et gérez des offres d'emploi",
                    ontap: () async {
                      final school = SchoolModel(
                        name: state.userModel.displayName!,
                        uid: state.userModel.uid,
                        email: state.userModel.email,
                        town: "",
                        yearOfEstablishment: 2025,
                        primaryPhone: "",

                        department: "",
                        createdAt: DateTime.now(),
                      );
                      context.read<SchoolBloc>().add(CreateSchool(school));
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  _buildTypeCard(
                    context,
                    title: "Visiteur",
                    icon: Icons.person,
                    type: 'visitor',
                    description: "Parents, élèves ou autres visiteurs",
                    ontap: () async {
                      // // Étape 6: Sauvegarde dans Firestore
                      final user = UserModel(
                        email: state.userModel.email,
                        uid: state.userModel.uid,
                        displayName: state.userModel.displayName!,
                        photoUrl: state.userModel.photoUrl,
                        plan: state.userModel.plan,
                        planExpiryDate: DateTime.now(),
                      );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(state.userModel.uid)
                          .set(user.toMap());
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String type,
    String? description,
    required void Function()? ontap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<AuthBloc>().add(
            UpdateAccountType(uid: user.uid, accountType: type),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.red),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(description),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
