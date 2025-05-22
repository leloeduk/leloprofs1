import 'package:flutter/material.dart';

import '../../domain/models/teacher_model.dart';

class EditTeacherPage extends StatefulWidget {
  final TeacherModel teacher;

  const EditTeacherPage({super.key, required this.teacher});

  @override
  State<EditTeacherPage> createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _secondaryPhoneController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _departmentController;
  late TextEditingController _countryController;
  late TextEditingController _yearsOfExperienceController;

  List<String> _diplomas = [];
  List<String> _educationCycles = [];
  List<String> _subjects = [];
  List<String> _languages = [];

  bool _isAvailable = true;
  bool _isInspector = false;

  late DateTime _dateOfBirth;
  late DateTime _dateOfRecruitment;

  @override
  void initState() {
    super.initState();
    final t = widget.teacher;

    _firstNameController = TextEditingController(text: t.firstName);
    _lastNameController = TextEditingController(text: t.lastName);
    _phoneNumberController = TextEditingController(text: t.phoneNumber);
    _secondaryPhoneController = TextEditingController(
      text: t.secondaryPhone ?? '',
    );
    _emergencyContactController = TextEditingController(
      text: t.emergencyContact ?? '',
    );
    _departmentController = TextEditingController(text: t.department);
    _countryController = TextEditingController(text: t.country);
    _yearsOfExperienceController = TextEditingController(
      text: t.yearsOfExperience.toString(),
    );

    _diplomas = List.from(t.diplomas);
    _educationCycles = List.from(t.languages);
    _subjects = List.from(t.subjects);
    _languages = List.from(t.languages);

    _isAvailable = t.isAvailable;
    _isInspector = t.isInspector;

    _dateOfBirth = t.createdAt;
    // _dateOfRecruitment = "";
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
    if (!_formKey.currentState!.validate()) return;

    final updatedTeacher = TeacherModel(
      uid: widget.teacher.uid,
      email: widget.teacher.email,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      secondaryPhone:
          _secondaryPhoneController.text.trim().isEmpty
              ? null
              : _secondaryPhoneController.text.trim(),
      emergencyContact:
          _emergencyContactController.text.trim().isEmpty
              ? null
              : _emergencyContactController.text.trim(),
      department: _departmentController.text.trim(),
      country: _countryController.text.trim(),
      diplomas: _diplomas,
      yearsOfExperience: int.parse(_yearsOfExperienceController.text.trim()),
      // educationCycle: _educationCycles,
      subjects: _subjects,
      languages: _languages,
      isAvailable: _isAvailable,
      isInspector: _isInspector,
      // dateOfBirth: _dateOfBirth,
      // dateOfRecruitment: _dateOfRecruitment,
      // profileImage: widget.teacher.profileImage,
      // ratings: widget.teacher.ratings,
      createdAt: DateTime.now(),
    );

    // Met à jour Firestore ici

    Navigator.of(context).pop(updatedTeacher);
  }

  Future<void> _editList(String title, List<String> list) async {
    final TextEditingController _itemController = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Modifier $title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in list)
                  ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          list.remove(item);
                        });
                        Navigator.of(context).pop();
                        _editList(title, list);
                      },
                    ),
                  ),
                TextField(
                  controller: _itemController,
                  decoration: InputDecoration(labelText: 'Ajouter un élément'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_itemController.text.trim().isNotEmpty) {
                    setState(() {
                      list.add(_itemController.text.trim());
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Ajouter'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fermer'),
              ),
            ],
          ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onDatePicked,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) onDatePicked(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Enseignant'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextFields
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Prénom'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Téléphone principal'),
                keyboardType: TextInputType.phone,
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _secondaryPhoneController,
                decoration: InputDecoration(labelText: 'Téléphone secondaire'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emergencyContactController,
                decoration: InputDecoration(labelText: 'Contact d\'urgence'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'Département'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
              TextFormField(
                controller: _yearsOfExperienceController,
                decoration: InputDecoration(labelText: 'Années d\'expérience'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Champ obligatoire';
                  if (int.tryParse(v) == null) return 'Doit être un nombre';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dates
              ListTile(
                title: Text(
                  'Date de naissance : ${_dateOfBirth.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap:
                    () => _pickDate(
                      context,
                      _dateOfBirth,
                      (date) => setState(() => _dateOfBirth = date),
                    ),
              ),
              ListTile(
                title: Text(
                  'Date de recrutement : ${_dateOfRecruitment.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap:
                    () => _pickDate(
                      context,
                      _dateOfRecruitment,
                      (date) => setState(() => _dateOfRecruitment = date),
                    ),
              ),

              const SizedBox(height: 16),

              // Switches
              SwitchListTile(
                title: Text('Disponible'),
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
              ),
              SwitchListTile(
                title: Text('Inspecteur'),
                value: _isInspector,
                onChanged: (v) => setState(() => _isInspector = v),
              ),

              const SizedBox(height: 16),

              // Listes
              ElevatedButton(
                onPressed: () => _editList('Diplômes', _diplomas),
                child: Text('Modifier Diplômes (${_diplomas.length})'),
              ),
              ElevatedButton(
                onPressed:
                    () => _editList('Cycles d\'éducation', _educationCycles),
                child: Text(
                  'Modifier Cycles d\'éducation (${_educationCycles.length})',
                ),
              ),
              ElevatedButton(
                onPressed: () => _editList('Matières', _subjects),
                child: Text('Modifier Matières (${_subjects.length})'),
              ),
              ElevatedButton(
                onPressed: () => _editList('Langues', _languages),
                child: Text('Modifier Langues (${_languages.length})'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
