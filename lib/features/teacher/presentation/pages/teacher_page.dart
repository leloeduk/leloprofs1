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

            if (teachers.isEmpty) {
              return const Center(child: Text("Aucun enseignant trouvé."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: teachers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final teacher = teachers[index];

                return InkWell(
                  onTap:
                      () => context.push(
                        '/teacher/${teacher.id}',
                        extra: teacher,
                      ),
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                teacher.profileImageUrl != null
                                    ? NetworkImage(teacher.profileImageUrl!)
                                    : null,
                            child:
                                teacher.profileImageUrl == null
                                    ? const Icon(Icons.person, size: 30)
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${teacher.firstName} ${teacher.lastName}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      teacher.isAvailable
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          teacher.isAvailable
                                              ? Colors.green
                                              : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      teacher.isAvailable
                                          ? 'Disponible'
                                          : 'Non disponible',
                                      style: TextStyle(
                                        color:
                                            teacher.isAvailable
                                                ? Colors.green.shade800
                                                : Colors.red.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    _infoChip(
                                      Icons.workspace_premium,
                                      teacher.diplomas.first,
                                    ),
                                    _infoChip(
                                      Icons.menu_book,
                                      teacher.subjects.first,
                                    ),
                                    _infoChip(
                                      Icons.school,
                                      teacher.educationCycles.first,
                                    ),
                                  ],
                                ),
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

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.redAccent),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
