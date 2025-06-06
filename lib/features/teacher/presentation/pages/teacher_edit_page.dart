import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_event.dart';
import 'package:leloprof/utils/widgets/custom_section_title.dart';

import '../../../../core/services/firebase/firebase_storage_services.dart';
import '../../../../utils/widgets/custom_selected_image.dart';

class TeacherEditPage extends StatefulWidget {
  final TeacherModel teacher;

  const TeacherEditPage({required this.teacher, super.key});

  @override
  State<TeacherEditPage> createState() => _TeacherEditPageState();
}

class _TeacherEditPageState extends State<TeacherEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs texte
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _secondaryPhoneController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _departmentController;
  late TextEditingController _countryController;
  late TextEditingController _districtController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _workshopParticipationController;
  late TextEditingController _diplomaUrlController;
  late TextEditingController _cvUrlController;
  late TextEditingController _verifiedByController;

  // Listes modifiables
  late List<String> _diplomas;
  late List<String> _educationCycles;
  late List<String> _subjects;
  late List<String> _languages;

  // Variables booléennes
  bool _isAvailable = false;
  bool _isInspector = false;
  bool _isCivilServant = false;
  bool _isVerified = false;
  bool _isEnabled = true;
  bool _hasPaid = false;

  // Dates
  DateTime? _teacherSince;
  DateTime? _verifiedAt;
  DateTime? _lastAvailabilityUpdate;
  DateTime? _lastUpdate;

  // Autres
  double? _rating;
  SubscriptionPlan _plan = SubscriptionPlan.free;
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs existantes
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
    _districtController = TextEditingController(
      text: widget.teacher.district ?? '',
    );
    _yearsOfExperienceController = TextEditingController(
      text: widget.teacher.yearsOfExperience.toString(),
    );
    _workshopParticipationController = TextEditingController(
      text: widget.teacher.workshopParticipationCount.toString(),
    );
    _diplomaUrlController = TextEditingController(
      text: widget.teacher.diplomaUrl ?? '',
    );
    _cvUrlController = TextEditingController(text: widget.teacher.cvUrl ?? '');
    _verifiedByController = TextEditingController(
      text: widget.teacher.verifiedBy ?? '',
    );

    // Initialisation des listes
    _diplomas = List.from(widget.teacher.diplomas);
    _educationCycles = List.from(widget.teacher.educationCycles);
    _subjects = List.from(widget.teacher.subjects);
    _languages = List.from(widget.teacher.languages);

    // Initialisation des booléens
    _isAvailable = widget.teacher.isAvailable;
    _isInspector = widget.teacher.isInspector;
    _isCivilServant = widget.teacher.isCivilServant;
    _isVerified = widget.teacher.isVerified;
    _isEnabled = widget.teacher.isEnabled;
    _hasPaid = widget.teacher.hasPaid;

    // Initialisation des dates
    _teacherSince = widget.teacher.teacherSince;
    _verifiedAt = widget.teacher.verifiedAt;
    _lastAvailabilityUpdate = widget.teacher.lastAvailabilityUpdate;
    _lastUpdate = widget.teacher.lastUpdate;

    // Initialisation autres
    _rating = widget.teacher.rating;
    _plan = widget.teacher.plan;
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _secondaryPhoneController.dispose();
    _emergencyContactController.dispose();
    _departmentController.dispose();
    _countryController.dispose();
    _districtController.dispose();
    _yearsOfExperienceController.dispose();
    _workshopParticipationController.dispose();
    _diplomaUrlController.dispose();
    _cvUrlController.dispose();
    _verifiedByController.dispose();
    super.dispose();
  }

  _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String? imageUrl = widget.teacher.profileImageUrl;
        if (_selectedImage != null) {
          imageUrl = await FirebaseStorageService().uploadSchoolImage(
            "teachers",
            widget.teacher.id,
            widget.teacher.firstName,
            _selectedImage!,
          );
        }
        final updatedTeacher = widget.teacher.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          secondaryPhone:
              _secondaryPhoneController.text.trim().isNotEmpty
                  ? _secondaryPhoneController.text.trim()
                  : null,
          emergencyContact:
              _emergencyContactController.text.trim().isNotEmpty
                  ? _emergencyContactController.text.trim()
                  : null,
          department: _departmentController.text.trim(),
          country:
              _countryController.text.trim().isNotEmpty
                  ? _countryController.text.trim()
                  : null,
          district:
              _districtController.text.trim().isNotEmpty
                  ? _districtController.text.trim()
                  : null,
          yearsOfExperience:
              int.tryParse(_yearsOfExperienceController.text.trim()) ?? 0,
          workshopParticipationCount:
              int.tryParse(_workshopParticipationController.text.trim()) ?? 0,
          diplomas: _diplomas,
          educationCycles: _educationCycles,
          subjects: _subjects,
          languages: _languages,
          isAvailable: _isAvailable,
          isInspector: _isInspector,
          isCivilServant: _isCivilServant,
          isVerified: _isVerified,
          isEnabled: _isEnabled,
          hasPaid: _hasPaid,
          teacherSince: _teacherSince,
          verifiedAt: _verifiedAt,
          verifiedBy:
              _verifiedByController.text.trim().isNotEmpty
                  ? _verifiedByController.text.trim()
                  : null,
          lastAvailabilityUpdate: _lastAvailabilityUpdate,
          lastUpdate: _lastUpdate,
          rating: _rating,
          plan: _plan,
          diplomaUrl:
              _diplomaUrlController.text.trim().isNotEmpty
                  ? _diplomaUrlController.text.trim()
                  : null,
          cvUrl:
              _cvUrlController.text.trim().isNotEmpty
                  ? _cvUrlController.text.trim()
                  : null,
        );
        print(imageUrl);

        await context.read<TeacherBloc>().teacherRepository.updateTeacher(
          updatedTeacher,
        );
        context.read<TeacherBloc>().add(UpdateTeacher(updatedTeacher));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'upload de l\'image')),
        );
      }
      context.pop(true);
    }
    setState(() {});
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator:
          isRequired
              ? (val) {
                if (val == null || val.trim().isEmpty)
                  return 'Ce champ est requis';
                if (keyboardType == TextInputType.number &&
                    int.tryParse(val.trim()) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              }
              : null,
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
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      deleteIconColor: Theme.of(context).colorScheme.onError,
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
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
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
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : 'Sélectionner une date',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDropdown() {
    return DropdownButtonFormField<SubscriptionPlan>(
      value: _plan,
      decoration: InputDecoration(
        labelText: 'Type d\'abonnement',
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items:
          SubscriptionPlan.values.map((plan) {
            return DropdownMenuItem<SubscriptionPlan>(
              value: plan,
              child: Text(
                plan.toString().split('.').last,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _plan = value);
        }
      },
    );
  }

  Widget _buildRatingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note: ${_rating?.toStringAsFixed(1) ?? 'Non noté'}',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        Slider(
          value: _rating ?? 0,
          min: 0,
          max: 5,
          divisions: 10,
          label: _rating?.toStringAsFixed(1),
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          onChanged: (value) => setState(() => _rating = value),
        ),
      ],
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
              ReusableImagePicker(
                initialImageFile: null, // ou une File existante
                imageUrl: _selectedImage,
                onImageSelected: (file) {
                  // Enregistre ou envoie l'image sélectionnée
                  print("Image sélectionnée : ${file.path}");
                },
              ),
              CustomSectionTitle(title: 'Informations personnelles'),
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
                isRequired: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _emergencyContactController,
                'Contact urgence (facultatif)',
                keyboardType: TextInputType.phone,
                icon: Icons.contact_phone,
                isRequired: false,
              ),

              CustomSectionTitle(title: 'Informations professionnelles'),
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
                isRequired: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _districtController,
                'Arrondissement (facultatif)',
                icon: Icons.map,
                isRequired: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _yearsOfExperienceController,
                'Années d\'expérience',
                keyboardType: TextInputType.number,
                icon: Icons.timeline,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _workshopParticipationController,
                'Participations ateliers',
                keyboardType: TextInputType.number,
                icon: Icons.workspaces_outline,
              ),

              CustomSectionTitle(title: 'Documents'),
              _buildTextField(
                _diplomaUrlController,
                'URL Diplôme (facultatif)',
                icon: Icons.school,
                isRequired: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _cvUrlController,
                'URL CV (facultatif)',
                icon: Icons.description,
                isRequired: false,
              ),

              CustomSectionTitle(title: 'Compétences'),
              _buildEditableChipsList(_diplomas),
              const SizedBox(height: 25),
              _buildEditableChipsList(_educationCycles),
              const SizedBox(height: 25),
              _buildEditableChipsList(_subjects),
              const SizedBox(height: 25),
              _buildEditableChipsList(_languages),

              CustomSectionTitle(title: 'Statut & Vérification'),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Disponible',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _isAvailable,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) => setState(() => _isAvailable = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Inspecteur',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _isInspector,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) => setState(() => _isInspector = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Fonctionnaire',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _isCivilServant,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) =>
                              setState(() => _isCivilServant = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Vérifié',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _isVerified,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) => setState(() => _isVerified = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Activé',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _isEnabled,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) => setState(() => _isEnabled = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        'Payé',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      value: _hasPaid,
                      activeColor: Theme.of(context).colorScheme.error,
                      onChanged:
                          (val) => setState(() => _hasPaid = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                _verifiedByController,
                'Vérifié par (facultatif)',
                isRequired: false,
              ),
              const SizedBox(height: 15),
              _buildPlanDropdown(),
              const SizedBox(height: 8),
              _buildRatingSlider(),
              const SizedBox(height: 8),

              CustomSectionTitle(title: 'Dates importantes'),
              _buildDatePicker(
                'Enseigne depuis',
                _teacherSince,
                (date) => setState(() => _teacherSince = date),
              ),
              const SizedBox(height: 15),
              _buildDatePicker(
                'Date de vérification',
                _verifiedAt,
                (date) => setState(() => _verifiedAt = date),
              ),
              const SizedBox(height: 15),
              _buildDatePicker(
                'Dernière maj disponibilité',
                _lastAvailabilityUpdate,
                (date) => setState(() => _lastAvailabilityUpdate = date),
              ),
              const SizedBox(height: 15),
              _buildDatePicker(
                'Dernière mise à jour',
                _lastUpdate,
                (date) => setState(() => _lastUpdate = date),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
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
