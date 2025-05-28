import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';

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

  // Couleurs personnalisées (palette harmonieuse)
  final Color primaryColor = Color(0xFF005CAF); // bleu foncé
  final Color accentColor = Color(0xFFE95F29); // orange chaud
  final Color backgroundColor = Color(0xFFF7F9FC); // gris très clair
  final Color cardColor = Colors.white;
  final Color chipColor = Color(0xFFB3D4FC); // bleu clair pour chips
  final Color chipTextColor = Color(0xFF003366);

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
    // _dateOfBirth = widget.teacher.dateOfBirth;
    // _dateOfRecruitment = widget.teacher.dateOfRecruitment;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Modifier Enseignant',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Card(
          color: cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
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
                          activeColor: accentColor,
                          onChanged:
                              (val) =>
                                  setState(() => _isAvailable = val ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Inspecteur'),
                          value: _isInspector,
                          activeColor: accentColor,
                          onChanged:
                              (val) =>
                                  setState(() => _isInspector = val ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  _buildDatePicker('Date de naissance', _dateOfBirth, (date) {
                    setState(() => _dateOfBirth = date);
                  }),
                  const SizedBox(height: 15),
                  _buildDatePicker('Date de recrutement', _dateOfRecruitment, (
                    date,
                  ) {
                    setState(() => _dateOfRecruitment = date);
                  }),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryColor,
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
        prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildEditableChipsList(List<String> list) {
    final controller = TextEditingController();

    return StatefulBuilder(
      builder:
          (ctx, setDialogState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Aucun élément. Ajoutez-en un.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    list
                        .map(
                          (e) => Chip(
                            label: Text(
                              e,
                              style: TextStyle(color: chipTextColor),
                            ),
                            backgroundColor: chipColor,
                            deleteIconColor: accentColor,
                            onDeleted: () {
                              setDialogState(() => list.remove(e));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                        filled: true,
                        fillColor: backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      final val = controller.text.trim();
                      if (val.isNotEmpty && !list.contains(val)) {
                        setDialogState(() {
                          list.add(val);
                          controller.clear();
                        });
                      }
                    },
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    ValueChanged<DateTime> onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final initialDate = date ?? DateTime(now.year - 30);
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: now,
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: backgroundColor,
          prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
        ),
        child: Text(
          date == null
              ? 'Sélectionner une date'
              : '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            fontSize: 16,
            color: date == null ? Colors.grey[600] : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;

    final updatedTeacher = widget.teacher.copyWith(
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
      country:
          _countryController.text.trim().isEmpty
              ? null
              : _countryController.text.trim(),
      yearsOfExperience: int.parse(_yearsOfExperienceController.text.trim()),
      diplomas: List<String>.from(_diplomas),
      educationCycles: List<String>.from(_educationCycles),
      subjects: List<String>.from(_subjects),
      languages: List<String>.from(_languages),
      isAvailable: _isAvailable,
      isInspector: _isInspector,
      // dateOfBirth: _dateOfBirth,
      // dateOfRecruitment: _dateOfRecruitment,
    );

    context.read<TeacherBloc>().teacherRepository.updateTeacher(updatedTeacher);

    Navigator.pop(context);
  }
}
