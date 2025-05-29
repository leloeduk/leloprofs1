import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';

import '../bloc/bloc/teacher_event.dart';

class TeacherEditPage extends StatefulWidget {
  final TeacherModel teacher;

  const TeacherEditPage({required this.teacher, super.key});

  @override
  State<TeacherEditPage> createState() => _TeacherEditPageState();
}

class _TeacherEditPageState extends State<TeacherEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _secondaryPhoneController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _departmentController;
  late TextEditingController _countryController;
  late TextEditingController _yearsOfExperienceController;

  late List<String> _diplomas;
  late List<String> _educationCycles;
  late List<String> _subjects;
  late List<String> _languages;

  bool _isAvailable = false;
  bool _isInspector = false;

  DateTime? _dateOfBirth;
  DateTime? _dateOfRecruitment;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.teacher.firstName,
    );
    _lastNameController = TextEditingController(text: widget.teacher.lastName);
    _phoneNumberController = TextEditingController(
      text: widget.teacher.phoneNumber,
    );
    _secondaryPhoneController = TextEditingController(
      text: widget.teacher.secondaryPhone ?? '',
    );
    _emergencyContactController = TextEditingController(
      text: widget.teacher.emergencyContact ?? '',
    );
    _departmentController = TextEditingController(
      text: widget.teacher.department,
    );
    _countryController = TextEditingController(
      text: widget.teacher.country ?? '',
    );
    _yearsOfExperienceController = TextEditingController(
      text: widget.teacher.yearsOfExperience.toString(),
    );

    _diplomas = List<String>.from(widget.teacher.diplomas);
    _educationCycles = List<String>.from(widget.teacher.educationCycles);
    _subjects = List<String>.from(widget.teacher.subjects);
    _languages = List<String>.from(widget.teacher.languages);

    _isAvailable = widget.teacher.isAvailable;
    _isInspector = widget.teacher.isInspector;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _secondaryPhoneController.dispose();
    _emergencyContactController.dispose();
    _departmentController.dispose();
    _countryController.dispose();
    _yearsOfExperienceController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTeacher = widget.teacher.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        secondaryPhone: _secondaryPhoneController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
        department: _departmentController.text.trim(),
        country: _countryController.text.trim(),
        yearsOfExperience:
            int.tryParse(_yearsOfExperienceController.text.trim()) ?? 0,
        diplomas: _diplomas,
        educationCycles: _educationCycles,
        subjects: _subjects,
        languages: _languages,
        isAvailable: _isAvailable,
        isInspector: _isInspector,
      );

      context.read<TeacherBloc>().add(UpdateTeacher(updatedTeacher));
      Navigator.pop(context);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSecondary,
          letterSpacing: 0.6,
        ),
      ),
    );
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
            int.tryParse(val.trim()) == null)
          return 'Veuillez entrer un nombre valide';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            icon != null
                ? Icon(icon, color: Theme.of(context).colorScheme.primary)
                : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onError,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
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
          runSpacing: 8,
          children:
              list
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      onDeleted: () => setState(() => list.remove(e)),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Ajouter un élément',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
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

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    ValueChanged<DateTime> onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Sélectionner une date',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Modifier Enseignant',
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informations personnelles'),
              _buildTextField(
                _firstNameController,
                'Prénom',
                icon: Icons.person,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _lastNameController,
                'Nom',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _phoneNumberController,
                'Téléphone principal',
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _secondaryPhoneController,
                'Téléphone secondaire (facultatif)',
                keyboardType: TextInputType.phone,
                icon: Icons.phone_android,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _emergencyContactController,
                'Contact urgence (facultatif)',
                keyboardType: TextInputType.phone,
                icon: Icons.contact_phone,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _departmentController,
                'Département',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _countryController,
                'Pays (facultatif)',
                icon: Icons.public,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _yearsOfExperienceController,
                'Années d\'expérience',
                keyboardType: TextInputType.number,
                icon: Icons.timeline,
              ),

              const SizedBox(height: 25),
              _buildSectionTitle('Diplômes'),
              _buildEditableChipsList(_diplomas),
              const SizedBox(height: 25),
              _buildSectionTitle('Cycles éducatifs'),
              _buildEditableChipsList(_educationCycles),
              const SizedBox(height: 25),
              _buildSectionTitle('Matières'),
              _buildEditableChipsList(_subjects),
              const SizedBox(height: 25),
              _buildSectionTitle('Langues'),
              _buildEditableChipsList(_languages),

              const SizedBox(height: 25),
              _buildSectionTitle('Disponibilités & Rôles'),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Disponible'),
                      value: _isAvailable,
                      activeColor: Theme.of(context).colorScheme.onError,
                      onChanged:
                          (val) => setState(() => _isAvailable = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('Inspecteur'),
                      value: _isInspector,
                      activeColor: Theme.of(context).colorScheme.onError,
                      onChanged:
                          (val) => setState(() => _isInspector = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              _buildDatePicker(
                'Date de naissance',
                _dateOfBirth,
                (date) => setState(() => _dateOfBirth = date),
              ),
              const SizedBox(height: 15),
              _buildDatePicker(
                'Date de recrutement',
                _dateOfRecruitment,
                (date) => setState(() => _dateOfRecruitment = date),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
