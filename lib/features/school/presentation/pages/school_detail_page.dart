import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';

class SchoolDetailPage extends StatelessWidget {
  final SchoolModel school;

  const SchoolDetailPage({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    final isOwner =
        context.read<AuthBloc>().state is Authenticated &&
        (context.read<AuthBloc>().state as Authenticated).user.id == school.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(school.name),
        actions:
            isOwner
                ? [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed:
                        () => context.push('/edit-school', extra: school),
                  ),
                ]
                : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (school.profileImageUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(school.profileImageUrl!),
                ),
              ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                school.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailSection(context, [
              _buildItem("Ville", school.town),
              _buildItem("Département", school.department),
              _buildItem("Pays", school.country),
              _buildItem("Téléphone principal", school.primaryPhone),
              if (school.secondaryPhone != null)
                _buildItem("Téléphone secondaire", school.secondaryPhone!),
              if (school.emergencyPhone != null)
                _buildItem("Téléphone d'urgence", school.emergencyPhone!),
              _buildItem("Email", school.email),
              _buildItem("Année de création", "${school.yearOfEstablishment}"),
              _buildItem("Source de création", school.creationSource),
              _buildItem("Statut", school.isActive ? "Actif" : "Inactif"),
              _buildItem("Vérifié", school.isVerified ? "Oui" : "Non"),
            ]),
            const SizedBox(height: 16),
            _buildTagSection("Types d'école", school.types),
            _buildTagSection("Cycles éducatifs", school.educationCycle),
            const SizedBox(height: 24),
            Text(
              "À propos de l'école",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              school.bio ?? "Aucune description disponible.",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          children
              .map(
                (child) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: child,
                ),
              )
              .toList(),
    );
  }

  Widget _buildItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(value),
        const Divider(),
      ],
    );
  }

  Widget _buildTagSection(String label, List<String> tags) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children:
              tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: const TextStyle(color: Colors.blue),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
