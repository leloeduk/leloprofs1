import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/teacher_bloc.dart';
import '../bloc/bloc/teacher_event.dart';
import '../bloc/bloc/teacher_state.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les enseignants à l'ouverture de la page
    context.read<TeacherBloc>().add(LoadTeachers());

    return Scaffold(
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if (state is TeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeacherError) {
            return Center(child: Text(state.message));
          } else if (state is TeacherLoaded) {
            final teachers = state.teachers;

            if (teachers.isEmpty) {
              return const Center(child: Text("Aucun enseignant trouvé."));
            }

            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage:
                  //       teacher. != null
                  //           ? NetworkImage(teacher.profileImage!)
                  //           : null,
                  //   child:
                  //       teacher.profileImage == null
                  //           ? const Icon(Icons.person)
                  //           : null,
                  // ),
                  title: Text(teacher.firstName),
                  subtitle: Text(
                    '${teacher.subjects.first} • ${teacher.department}',
                  ),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () {
                  //     context.read<TeacherBloc>().add(
                  //       DeleteTeacher(teacher.uid),
                  //     );
                  // },
                  // ),
                  onTap: () {
                    // Action quand on clique sur un enseignant (ex: détails, édition)
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("État inconnu."));
          }
        },
      ),
    );
  }
}
