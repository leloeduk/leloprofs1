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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

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

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: schools.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final school = schools[index];

                return Material(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap:
                        () =>
                            context.push('/school/${school.id}', extra: school),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                school.profileImageUrl != null
                                    ? NetworkImage(school.profileImageUrl!)
                                    : null,
                            child:
                                school.profileImageUrl == null
                                    ? const Icon(
                                      Icons.school,
                                      size: 32,
                                      color: Colors.white70,
                                    )
                                    : null,
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        school.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _VerificationBadge(
                                      isVerified: school.isVerified,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  children: [
                                    if (school.types.isNotEmpty)
                                      _InfoChip(
                                        icon: Icons.workspace_premium,
                                        label: school.types.last,
                                        color: theme.colorScheme.primary,
                                      ),
                                    if (school.educationCycle.isNotEmpty)
                                      _InfoChip(
                                        icon: Icons.school,
                                        label: school.educationCycle.last,
                                        color: theme.colorScheme.secondary,
                                      ),
                                    _InfoChip(
                                      icon: Icons.location_on,
                                      label: school.town,
                                      color: theme.colorScheme.tertiary,
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
}

class _VerificationBadge extends StatelessWidget {
  final bool isVerified;
  const _VerificationBadge({required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.check_circle : Icons.error,
            size: 16,
            color: isVerified ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isVerified ? "Vérifiée" : "Non vérifiée",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isVerified ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
