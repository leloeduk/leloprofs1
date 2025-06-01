import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entities/user_model.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final bool canEdit = widget.teacher.id == widget.currentUserId;
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
                  widget.teacher.profileImageUrl != null
                      ? Image.network(
                        widget.teacher.profileImageUrl!,
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
                      () => context.pushNamed(
                        'edit-teacher',
                        extra: widget.teacher,
                      ),
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
                        widget.teacher.profileImageUrl != null
                            ? NetworkImage(widget.teacher.profileImageUrl!)
                            : null,
                    child:
                        widget.teacher.profileImageUrl == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                    backgroundColor: Colors.red.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.teacher.firstName} ${widget.teacher.lastName}',
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
                          widget.teacher.isAvailable
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.teacher.isAvailable
                          ? "✅ Disponible"
                          : "❌ Non disponible",
                      style: TextStyle(
                        color:
                            widget.teacher.isAvailable
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
                  _buildImagePicker(),
                  const SizedBox(height: 10),
                  _buildInfoSection(
                    context,
                    Icons.school,
                    'Département',
                    widget.teacher.department,
                  ),
                  _buildInfoSection(
                    context,
                    Icons.phone,
                    'Téléphone',
                    widget.teacher.phoneNumber,
                  ),
                  if (widget.teacher.secondaryPhone != null)
                    _buildInfoSection(
                      context,
                      Icons.phone_android,
                      'Autre téléphone',
                      widget.teacher.secondaryPhone!,
                    ),
                  if (widget.teacher.country != null)
                    _buildInfoSection(
                      context,
                      Icons.flag,
                      'Pays',
                      widget.teacher.country!,
                    ),
                  _buildInfoSection(
                    context,
                    Icons.workspace_premium,
                    'Diplômes',
                    widget.teacher.diplomas.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.timeline,
                    'Expérience',
                    '${widget.teacher.yearsOfExperience} ans',
                  ),
                  _buildInfoSection(
                    context,
                    Icons.book,
                    'Matières',
                    widget.teacher.subjects.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.language,
                    'Langues',
                    widget.teacher.languages.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.school_outlined,
                    'Cycles éducatifs',
                    widget.teacher.educationCycles.join(", "),
                  ),
                  _buildInfoSection(
                    context,
                    Icons.verified,
                    'Inspecteur',
                    widget.teacher.isInspector ? "Oui" : "Non",
                  ),
                  if (widget.teacher.teacherSince != null)
                    _buildInfoSection(
                      context,
                      Icons.date_range,
                      'Enseigne depuis',
                      '${widget.teacher.teacherSince!.year}',
                    ),
                  if (widget.teacher.rating != null)
                    _buildInfoSection(
                      context,
                      Icons.star,
                      'Note',
                      '${widget.teacher.rating!.toStringAsFixed(1)} / 5',
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

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (widget.teacher.profileImageUrl != null
                        ? NetworkImage(widget.teacher.profileImageUrl!)
                        : AssetImage('assets/images/default_school.png')
                            as ImageProvider),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                child: Icon(Icons.camera_alt, color: Colors.white),
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
