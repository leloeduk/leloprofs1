import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/teacher_bloc.dart';
import '../bloc/bloc/teacher_event.dart';
import '../bloc/bloc/teacher_state.dart';

class TeacherPage extends StatefulWidget {
  final String role;
  const TeacherPage({super.key, required this.role});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(LoadTeachers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erreur : ${state.message}")));
        }
      },
      builder: (context, state) {
        if (state is TeacherLoaded) {
          final teachers = state.teachers;
          if (teachers.isEmpty) {
            return const Center(child: Text("Aucun enseignant trouvé."));
          }

          final authState = context.read<AuthBloc>().state;
          final currentUserId =
              authState is Authenticated ? authState.user.id : null;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              final canEdit =
                  widget.role == 'enseignant' && teacher.id == currentUserId;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading:
                      teacher.profileImageUrl != null
                          ? CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              teacher.profileImageUrl!,
                            ),
                          )
                          : const CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.person, size: 28),
                          ),
                  title: Text(
                    teacher.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        teacher.email ?? "Email non renseigné",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rôle : ${teacher.role ?? 'Enseignant'}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing:
                      canEdit
                          ? IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed:
                                () => context.push(
                                  '/edit-teacher',
                                  extra: teacher,
                                ),
                            tooltip: "Modifier cet enseignant",
                          )
                          : null,
                ),
              );
            },
          );
        } else if (state is TeacherError) {
          return Center(child: Text('Erreur : ${state.message}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
