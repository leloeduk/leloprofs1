import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';

class TeacherDetailPage extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherDetailPage({
    super.key,
    required this.teacher,
    required String teacherId,
    // L'argument teacherId n'est pas utilisé, tu peux le supprimer si inutile.
  });

  @override
  Widget build(BuildContext context) {
    final isOwner =
        context.read<AuthBloc>().state is Authenticated &&
        (context.read<AuthBloc>().state as Authenticated).user.id == teacher.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('${teacher.firstName} ${teacher.lastName}'),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/edit-teacher', extra: teacher),
              tooltip: 'Modifier ce profil',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.2),
              child: Text(
                '${teacher.firstName[0]}${teacher.lastName[0]}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${teacher.firstName} ${teacher.lastName}',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.email ?? 'Email non renseigné',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            _buildDetailItem(context, 'Département', teacher.department),
            _buildDetailItem(context, 'Téléphone', teacher.phoneNumber),
            _buildDetailItem(
              context,
              'Spécialité',
              teacher.educationCycles.isNotEmpty
                  ? teacher.educationCycles.first
                  : 'Non précisé',
            ),
            _buildDetailItem(
              context,
              'Années d\'expérience',
              teacher.yearsOfExperience.toString(),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bio',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.secondaryPhone ?? 'Aucune biographie disponible.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
