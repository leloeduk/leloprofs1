import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/domain/entities/user_model.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

class TeacherDetailPage extends StatelessWidget {
  final TeacherModel teacher;
  final String currentUserId;

  const TeacherDetailPage({
    super.key,
    required this.teacher,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final bool canEdit = teacher.id == currentUserId;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  teacher.profileImageUrl != null
                      ? Image.network(
                        teacher.profileImageUrl!,
                        fit: BoxFit.cover,
                      )
                      : Container(color: Colors.grey.shade800),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed:
                      () => context.pushNamed('edit-teacher', extra: teacher),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        teacher.profileImageUrl != null
                            ? NetworkImage(teacher.profileImageUrl!)
                            : null,
                    child:
                        teacher.profileImageUrl == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                    backgroundColor: Colors.red.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${teacher.firstName} ${teacher.lastName}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          teacher.isAvailable
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      teacher.isAvailable ? "✅ Disponible" : "❌ Non disponible",
                      style: TextStyle(
                        color:
                            teacher.isAvailable
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Présentation ou contenu à ajouter ici",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildInfoSection(
                    context,
                    Icons.school,
                    'Département',
                    teacher.department,
                  ),
                  _buildInfoSection(
                    context,
                    Icons.phone,
                    'Téléphone',
                    teacher.phoneNumber,
                  ),
                  if (teacher.secondaryPhone != null)
                    _buildInfoSection(
                      context,
                      Icons.phone_android,
                      'Autre téléphone',
                      teacher.secondaryPhone!,
                    ),
                  if (teacher.country != null)
                    _buildInfoSection(
                      context,
                      Icons.flag,
                      'Pays',
                      teacher.country!,
                    ),
                  _buildInfoSection(
                    context,
                    Icons.workspace_premium,
                    'Diplômes',
                    teacher.diplomas.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.timeline,
                    'Expérience',
                    '${teacher.yearsOfExperience} ans',
                  ),
                  _buildInfoSection(
                    context,
                    Icons.book,
                    'Matières',
                    teacher.subjects.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.language,
                    'Langues',
                    teacher.languages.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.school_outlined,
                    'Cycles éducatifs',
                    teacher.educationCycles.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.verified,
                    'Inspecteur',
                    teacher.isInspector ? "Oui" : "Non",
                  ),
                  if (teacher.teacherSince != null)
                    _buildInfoSection(
                      context,
                      Icons.date_range,
                      'Enseigne depuis',
                      '${teacher.teacherSince!.year}',
                    ),
                  if (teacher.rating != null)
                    _buildInfoSection(
                      context,
                      Icons.star,
                      'Note',
                      '${teacher.rating!.toStringAsFixed(1)} / 5',
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
