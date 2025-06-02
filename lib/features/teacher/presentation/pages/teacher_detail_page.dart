import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/widgets/custom_section_title.dart';
import '../../../auth/domain/entities/user_model.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

import '../bloc/bloc/teacher_bloc.dart';

class TeacherDetailPage extends StatefulWidget {
  final TeacherModel teacher;
  final String currentUserId;

  const TeacherDetailPage({
    super.key,
    required this.teacher,
    required this.currentUserId,
  });

  @override
  State<TeacherDetailPage> createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _refreshTeacherData() async {
    final updatedTeacher = await context
        .read<TeacherBloc>()
        .teacherRepository
        .getTeacherById(teacher!.id);
    setState(() {
      teacher = updatedTeacher;
    });
  }

  TeacherModel? teacher;

  @override
  void initState() {
    super.initState();
    teacher = widget.teacher;
  }

  @override
  Widget build(BuildContext context) {
    final bool canEdit = teacher!.id == widget.currentUserId;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  teacher!.profileImageUrl != null
                      ? Image.network(
                        teacher!.profileImageUrl!,
                        fit: BoxFit.cover,
                      )
                      : Container(),
                  Container(color: colorScheme.tertiary),
                ],
              ),
            ),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await context.pushNamed(
                      'edit-teacher',
                      extra: teacher!,
                    );
                    if (result == true) {
                      _refreshTeacherData(); // Recharge les données
                    }
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        teacher!.profileImageUrl != null
                            ? NetworkImage(teacher!.profileImageUrl!)
                            : null,
                    backgroundColor: Colors.grey.shade600,
                    child:
                        teacher!.profileImageUrl == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${teacher!.firstName} ${teacher!.lastName}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              teacher!.isAvailable
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          teacher!.isAvailable
                              ? "✅ Disponible"
                              : "❌ Non disponible",
                          style: TextStyle(
                            color:
                                teacher!.isAvailable
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildStatusChip(
                        context,
                        'Vérifié',
                        Icons.verified,
                        Colors.green,
                      ),
                      _buildStatusChip(
                        context,
                        teacher!.plan.name.toUpperCase(),
                        _getPlanIcon(teacher!.plan),
                        _getPlanColor(teacher!.plan),
                      ),
                    ],
                  ),
                  // Nouveaux indicateurs d'état
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (teacher!.isVerified)
                        _buildStatusChip(
                          context,
                          'Vérifié',
                          Icons.verified,
                          Colors.green,
                        ),
                      // if (teacher.isCivilServant)
                      _buildStatusChip(
                        context,
                        'Fonctionnaire',
                        Icons.badge,
                        Colors.blue,
                      ),
                      _buildStatusChip(
                        context,
                        teacher!.plan.name.toUpperCase(),
                        _getPlanIcon(teacher!.plan),
                        _getPlanColor(teacher!.plan),
                      ),
                      if (!teacher!.isEnabled)
                        _buildStatusChip(
                          context,
                          'Désactivé',
                          Icons.block,
                          Colors.red,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomSectionTitle(title: " Apropos de Moi "),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          teacher!.bio.isNotEmpty
                              ? teacher!.bio
                              : "Pas d'informations à afficher ...",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomSectionTitle(title: "Informations Professionnelles"),
                  _buildInfoSection(
                    context,
                    Icons.book,
                    'Matières',
                    teacher!.subjects.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.workspace_premium,
                    'Diplômes',
                    teacher!.diplomas.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.school_outlined,
                    'Cycles éducatifs',
                    teacher!.educationCycles.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.timeline,
                    'Expérience',
                    '${teacher!.yearsOfExperience} ans',
                  ),
                  if (teacher!.languages.isNotEmpty)
                    _buildInfoSection(
                      context,
                      Icons.language,
                      'Langues',
                      teacher!.languages.join(", "),
                    ),

                  _buildInfoSection(
                    context,
                    Icons.verified,
                    'Inspecteur',
                    teacher!.isInspector
                        ? "Oui ,  je suis un inspecteur"
                        : "Non , je ne suis pas un inspecteur",
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSectionTitle(title: "Documents Personnels"),
                  if (teacher!.diplomaUrl != null)
                    TextButton.icon(
                      icon: Icon(Icons.school, color: colorScheme.primary),
                      label: Text(
                        'Voir les diplômes',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                      onPressed: () {
                        // TODO: Implémenter la visualisation des diplômes
                      },
                    ),
                  if (teacher!.cvUrl != null)
                    TextButton.icon(
                      icon: Icon(Icons.description, color: colorScheme.primary),
                      label: Text(
                        'Voir le CV',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                      onPressed: () {
                        // TODO: Implémenter la visualisation du CV
                      },
                    ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          teacher!.bio.isNotEmpty
                              ? teacher!.bio
                              : "Ajouter un document à afficher ici ...",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomSectionTitle(title: "Contacts Personnels"),

                  _buildInfoSection(
                    context,
                    Icons.phone,
                    'Téléphone',
                    teacher!.phoneNumber,
                  ),
                  if (teacher!.secondaryPhone != null)
                    _buildInfoSection(
                      context,
                      Icons.phone_android,
                      'Autre téléphone',
                      teacher!.secondaryPhone!,
                    ),

                  _buildInfoSection(
                    context,
                    Icons.location_on,
                    'Arrondissement',
                    teacher!.district == null
                        ? "Non renseigné"
                        : teacher!.district!,
                  ),
                  _buildInfoSection(
                    context,
                    Icons.school,
                    'Département',
                    teacher!.department,
                  ),
                  _buildInfoSection(
                    context,
                    Icons.flag,
                    'Pays',
                    teacher!.country == null
                        ? teacher!.country!
                        : "Non renseignée",
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomSectionTitle(title: " Status "),
                  _buildInfoSection(
                    context,
                    Icons.verified_user,
                    'Compte vérifié',
                    teacher!.isVerified
                        ? " Ce compte est vérifié"
                        : "Ce compte n'est pas vérifié",
                  ),
                  _buildInfoSection(
                    context,
                    Icons.badge,
                    teacher!.isCivilServant
                        ? 'Fonctionnaire'
                        : 'Non fonctionnaire',
                    teacher!.isCivilServant ? "Oui" : "Non",
                  ),
                  _buildInfoSection(
                    context,
                    Icons.credit_card,
                    'Abonnement',
                    teacher!.plan.name.toUpperCase(),
                  ),
                  if (teacher!.workshopParticipationCount > 0)
                    _buildInfoSection(
                      context,
                      Icons.workspaces_outline,
                      'Ateliers participés',
                      '${teacher!.workshopParticipationCount}',
                    ),
                  if (teacher!.teacherSince != null)
                    _buildInfoSection(
                      context,
                      Icons.date_range,
                      'Enseigne depuis',
                      '${teacher!.teacherSince!.year}',
                    ),
                  _buildInfoSection(
                    context,
                    Icons.star,
                    'Note',

                    teacher!.rating != null
                        ? '${teacher!.rating!.toStringAsFixed(1)} / 5'
                        : 'Pas de note',
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

  Widget _buildStatusChip(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  IconData _getPlanIcon(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return Icons.free_breakfast;
      case SubscriptionPlan.elite:
        return Icons.star_half;
      case SubscriptionPlan.pro:
        return Icons.star;
    }
  }

  Color _getPlanColor(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return Colors.grey;
      case SubscriptionPlan.elite:
        return Colors.blue;
      case SubscriptionPlan.pro:
        return Colors.orange;
    }
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
