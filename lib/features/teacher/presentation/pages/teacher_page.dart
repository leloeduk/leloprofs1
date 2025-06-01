import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/teacher_bloc.dart';
import '../bloc/bloc/teacher_event.dart';
import '../bloc/bloc/teacher_state.dart';
import 'permission.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is TeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TeacherLoaded) {
            final teachers = state.teachers;
            final authState = context.read<AuthBloc>().state;
            final currentUserId =
                authState is Authenticated ? authState.user.id : null;

            if (teachers.isEmpty) {
              return const Center(child: Text("Aucun enseignant trouvé."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];

                return GestureDetector(
                  onTap:
                      () => context.push(
                        '/teacher/${teacher.id}',
                        extra: teacher,
                      ),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                teacher.profileImageUrl != null
                                    ? NetworkImage(teacher.profileImageUrl!)
                                    : null,
                            child:
                                teacher.profileImageUrl == null
                                    ? const Icon(Icons.person, size: 30)
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${teacher.firstName} ${teacher.lastName}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      teacher.isAvailable
                                          ? "✅Disponible"
                                          : "❌Non disponible",
                                      style: TextStyle(
                                        color:
                                            teacher.isAvailable
                                                ? Colors.green.shade900
                                                : Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.workspace_premium,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          teacher.diplomas.first,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          teacher.subjects.first,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          teacher.educationCycles.first,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is TeacherError) {
            return Center(child: Text("Erreur : ${state.message}"));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
