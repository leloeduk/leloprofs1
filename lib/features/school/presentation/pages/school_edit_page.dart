import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';

import '../../../school/presentation/bloc/bloc/school_bloc.dart';
import '../../../school/presentation/bloc/bloc/school_event.dart';
import '../../../school/presentation/bloc/bloc/school_state.dart';

class SchoolEditPage extends StatefulWidget {
  final SchoolModel school;

  const SchoolEditPage({super.key, required this.school});

  @override
  State<SchoolEditPage> createState() => _SchoolEditPageState();
}

class _SchoolEditPageState extends State<SchoolEditPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _townController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _departmentController;
  late TextEditingController _yearOfEstablishmentController;
  late TextEditingController _bioController;

  late List<String> _types;
  late List<String> _educationCycles;

  bool _enable = true;
  bool _isPay = false;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.school.name);
    _townController = TextEditingController(text: widget.school.town);
    _emailController = TextEditingController(text: widget.school.email ?? '');
    _phoneNumberController = TextEditingController(
      text: widget.school.secondaryPhone,
    );
    _departmentController = TextEditingController(
      text: widget.school.department,
    );
    _yearOfEstablishmentController = TextEditingController(
      text: widget.school.yearOfEstablishment.toString(),
    );
    _bioController = TextEditingController(text: widget.school.bio ?? '');

    _types = List<String>.from(widget.school.types);
    _educationCycles = List<String>.from(widget.school.educationCycle);
    _enable = widget.school.isActive;
    _isPay = widget.school.isVerified;
    _isPremium = widget.school.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _townController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    _yearOfEstablishmentController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedSchool = widget.school.copyWith(
        name: _nameController.text.trim(),
        town: _townController.text.trim(),
        email: _emailController.text.trim(),
        // phoneNumber: _phoneNumberController.text.trim(),
        department: _departmentController.text.trim(),
        yearOfEstablishment:
            int.tryParse(_yearOfEstablishmentController.text.trim()) ?? 2000,
        bio: _bioController.text.trim(),
        types: _types,
        educationCycle: _educationCycles,
        // enable: _enable,
        // isPay: _isPay,
        // isPremium: _isPremium,
      );

      context.read<SchoolBloc>().add(UpdateSchool(updatedSchool));
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (val) {
        if (val == null || val.trim().isEmpty) return 'Ce champ est requis';
        if (keyboardType == TextInputType.number &&
            int.tryParse(val.trim()) == null) {
          return 'Entrez un nombre valide';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEditableChipsList(List<String> list) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children:
              list
                  .map(
                    (item) => Chip(
                      label: Text(item),
                      onDeleted: () => setState(() => list.remove(item)),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Ajouter un élément',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() => list.add(text));
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildImagePicker() {
    return Container(
      height: 150,
      width: 100,
      color: Colors.amber,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.school.profileImageUrl != null
                          ? NetworkImage(widget.school.profileImageUrl!)
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier École')),
      body: BlocListener<SchoolBloc, SchoolState>(
        listener: (context, state) {
          if (state is SchoolLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('École mise à jour avec succès')),
            );
          } else if (state is SchoolError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de la mise à jour')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImagePicker(),
                const SizedBox(height: 15),

                _buildTextField(
                  _nameController,
                  'Nom de l\'école',
                  icon: Icons.school,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _townController,
                  'Ville',
                  icon: Icons.location_city,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _emailController,
                  'Email',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _phoneNumberController,
                  'Téléphone',
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _departmentController,
                  'Département',
                  icon: Icons.map,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _yearOfEstablishmentController,
                  'Année de création',
                  keyboardType: TextInputType.number,
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  _bioController,
                  'Biographie',
                  icon: Icons.info_outline,
                ),

                const SizedBox(height: 25),
                _buildEditableChipsList(_types),
                const SizedBox(height: 25),
                _buildEditableChipsList(_educationCycles),

                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Activée'),
                  value: _enable,
                  onChanged: (val) => setState(() => _enable = val),
                ),
                SwitchListTile(
                  title: Text('École payante'),
                  value: _isPay,
                  onChanged: (val) => setState(() => _isPay = val),
                ),
                SwitchListTile(
                  title: Text('Premium'),
                  value: _isPremium,
                  onChanged: (val) => setState(() => _isPremium = val),
                ),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(Icons.save),
                  label: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
