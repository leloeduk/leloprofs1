import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_event.dart';

import '../bloc/bloc/school_bloc.dart';

class SchoolEditPage extends StatefulWidget {
  final SchoolModel school;

  const SchoolEditPage({super.key, required this.school});

  @override
  State<SchoolEditPage> createState() => _SchoolEditPageState();
}

class _SchoolEditPageState extends State<SchoolEditPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _townController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _departmentController;
  late final TextEditingController _yearController;
  late final TextEditingController _bioController;

  late List<String> _types;
  late List<String> _educationCycles;
  late bool _isEnabled;
  late bool _isVerified;
  late bool _hasPaid;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _types = List.from(widget.school.types);
    _educationCycles = List.from(widget.school.educationCycle);
    _isEnabled = widget.school.isEnabled;
    _isVerified = widget.school.isVerified;
    _hasPaid = widget.school.hasPaid;
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.school.name);
    _townController = TextEditingController(text: widget.school.town);
    _emailController = TextEditingController(text: widget.school.email);
    _phoneNumberController = TextEditingController(
      text: widget.school.primaryPhone,
    );
    _departmentController = TextEditingController(
      text: widget.school.department,
    );
    _yearController = TextEditingController(
      text: widget.school.yearOfEstablishment.toString(),
    );
    _bioController = TextEditingController(text: widget.school.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _townController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    _yearController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedSchool = widget.school.copyWith(
        name: _nameController.text.trim(),
        town: _townController.text.trim(),
        email: _emailController.text.trim(),
        primaryPhone: _phoneNumberController.text.trim(),
        department: _departmentController.text.trim(),
        yearOfEstablishment: int.tryParse(_yearController.text.trim()) ?? 2000,
        bio: _bioController.text.trim(),
        types: _types,
        educationCycle: _educationCycles,
        isEnabled: _isEnabled,
        isVerified: _isVerified,
        hasPaid: _hasPaid,
        profileImageUrl: _selectedImage != null ? _selectedImage!.path : null,
      );

      // Envoyer l'événement de mise à jour
      context.read<SchoolBloc>().add(UpdateSchool(updatedSchool));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'école'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
            tooltip: 'Enregistrer',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Section Photo de profil
              _buildProfileSection(theme),
              const SizedBox(height: 24),

              // Section Informations de base
              _buildBasicInfoSection(colors),
              const SizedBox(height: 20),

              // Section À propos
              _buildAboutSection(),
              const SizedBox(height: 20),

              // Section Types et Cycles
              _buildTagsSection(),
              const SizedBox(height: 20),

              // Section Paramètres
              _buildSettingsSection(colors),
              const SizedBox(height: 30),

              // Bouton de sauvegarde
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Enregistrer les modifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Hero(
              tag: 'school-avatar-${widget.school.id}',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: theme.cardColor,
                backgroundImage: _getProfileImage(),
                child:
                    _selectedImage == null &&
                            widget.school.profileImageUrl == null
                        ? const Icon(Icons.school, size: 40)
                        : null,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 20),
                color: theme.colorScheme.onPrimary,
                onPressed: _pickImage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Changer la photo',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) return FileImage(_selectedImage!);
    if (widget.school.profileImageUrl != null) {
      return NetworkImage(widget.school.profileImageUrl!);
    }
    return null;
  }

  Widget _buildBasicInfoSection(ColorScheme colors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Nom de l\'école', Icons.school),
            const SizedBox(height: 12),
            _buildTextField(_townController, 'Ville', Icons.location_city),
            const SizedBox(height: 12),
            _buildTextField(
              _emailController,
              'Email',
              Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _phoneNumberController,
              'Téléphone',
              Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'À propos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextField(_departmentController, 'Département', Icons.map),
            const SizedBox(height: 12),
            _buildTextField(
              _yearController,
              'Année de création',
              Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: const Icon(Icons.info_outline),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChipsInput(
          label: 'Types d\'établissement',
          items: _types,
          icon: Icons.category,
        ),
        const SizedBox(height: 16),
        _buildChipsInput(
          label: 'Cycles éducatifs',
          items: _educationCycles,
          icon: Icons.school,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(ColorScheme colors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSwitchTile(
              'Activée',
              _isEnabled,
              (v) => setState(() => _isEnabled = v),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Vérifiée',
              _isVerified,
              (v) => setState(() => _isVerified = v),
            ),
            _buildDivider(),
            _buildSwitchTile(
              'Abonnement premium',
              _hasPaid,
              (v) => setState(() => _hasPaid = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ce champ est requis';
        if (keyboardType == TextInputType.number &&
            int.tryParse(value) == null) {
          return 'Veuillez entrer un nombre valide';
        }
        return null;
      },
    );
  }

  Widget _buildChipsInput({
    required String label,
    required List<String> items,
    required IconData icon,
  }) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                items
                    .map(
                      (item) => Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => setState(() => items.remove(item)),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Ajouter un élément',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() => items.add(controller.text.trim()));
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1),
    );
  }
}
