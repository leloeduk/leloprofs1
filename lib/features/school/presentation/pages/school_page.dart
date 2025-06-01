import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    if (context.read<SchoolBloc>().state is! SchoolLoaded) {
      context.read<SchoolBloc>().add(LoadSchools());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: BlocConsumer<SchoolBloc, SchoolState>(
        listener: (context, stateSchool) {
          if (stateSchool is SchoolError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur : ${stateSchool.message}")),
            );
          }
        },
        builder: (context, stateSchool) {
          if (stateSchool is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (stateSchool is SchoolLoaded) {
            final schools = stateSchool.schools;

            if (schools.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune école trouvée.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: schools.length,
              itemBuilder: (context, index) {
                final school = schools[index];

                return GestureDetector(
                  onTap:
                      () => context.push('/school/${school.id}', extra: school),
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
                                school.profileImageUrl != null
                                    ? NetworkImage(school.profileImageUrl!)
                                    : null,
                            child:
                                school.profileImageUrl == null
                                    ? const Icon(Icons.school, size: 30)
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
                                    Expanded(
                                      child: Text(
                                        school.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      school.isVerified
                                          ? "✅Verifiée"
                                          : "❌NonVerifiée",
                                      style: TextStyle(
                                        color:
                                            school.isVerified
                                                ? Colors.green.shade900
                                                : Colors.red.shade900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (school.types.isNotEmpty)
                                      Expanded(
                                        child: _buildInfo(
                                          Icons.workspace_premium,
                                          school.types.last,
                                        ),
                                      ),
                                    if (school.educationCycle.isNotEmpty)
                                      Expanded(
                                        child: _buildInfo(
                                          Icons.flag,
                                          school.educationCycle.last,
                                        ),
                                      ),
                                    Expanded(
                                      child: _buildInfo(
                                        Icons.location_on,
                                        school.town,
                                      ),
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

          if (stateSchool is SchoolError) {
            return Center(child: Text('Erreur : ${stateSchool.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.red),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
