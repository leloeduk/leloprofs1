import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/school_bloc.dart';
import '../bloc/bloc/school_event.dart';
import '../bloc/bloc/school_state.dart';

class SchoolPage extends StatefulWidget {
  final String role;
  const SchoolPage({super.key, required this.role});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(LoadSchools());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Liste des écoles"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: BlocConsumer<SchoolBloc, SchoolState>(
        listener: (context, state) {
          if (state is SchoolError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SchoolLoaded) {
            final schools = state.schools;

            if (schools.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune école trouvée.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final authState = context.read<AuthBloc>().state;
            final currentUserId =
                authState is Authenticated ? authState.user.id : null;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: schools.length,
              itemBuilder: (context, index) {
                final school = schools[index];
                final canEdit =
                    widget.role == 'ecole' && school.id == currentUserId;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.school, color: Colors.white, size: 28),
                    ),
                    title: Text(
                      school.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(school.town),
                        const SizedBox(height: 2),
                        Text(
                          school.email,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    trailing:
                        canEdit
                            ? IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed:
                                  () => context.push(
                                    '/edit-school',
                                    extra: school,
                                  ),
                            )
                            : null,
                    onTap: () => context.push('/school-details', extra: school),
                  ),
                );
              },
            );
          }

          if (state is SchoolError) {
            return Center(child: Text('Erreur : ${state.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
