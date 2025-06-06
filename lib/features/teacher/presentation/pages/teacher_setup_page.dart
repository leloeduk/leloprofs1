import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/core/services/firebase/firebase_storage_services.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_event.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_state.dart';
import 'package:leloprof/utils/models/listes.dart';
import 'package:leloprof/utils/widgets/custom_dropdown_button.dart';
import 'package:leloprof/utils/widgets/custom_selected_image.dart';
import 'package:leloprof/utils/widgets/custom_text_field.dart';
import 'package:leloprof/utils/widgets/custom_text_form_field_phone.dart';
import 'package:leloprof/utils/widgets/custom_wrap_selected.dart';

class TeacherSetupPage extends StatefulWidget {
  final UserModel initialUser;
  const TeacherSetupPage({super.key, required this.initialUser});

  @override
  State<TeacherSetupPage> createState() => _TeacherSetupPageState();
}

class _TeacherSetupPageState extends State<TeacherSetupPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();

  String? _selectedGender;
  Set<String> _selectedSubjects = {};
  Set<String> _selectedEducationCycle = {};
  String? _selectedDiploma;
  int? _yearsOfExperience;
  File? _profileImageFile;
  String? _selectedImageUrl;

  final FirebaseStorageService _storageService = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final parts = widget.initialUser.name?.split(' ') ?? [];
    if (parts.isNotEmpty) _firstNameController.text = parts.first;
    if (parts.length > 1) _lastNameController.text = parts.sublist(1).join(' ');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep == 0 && !_formKeyStep1.currentState!.validate()) {
      _showSnackBar("Veuillez remplir tous les champs requis", isError: true);
      return;
    }

    if (_currentStep == 1) {
      final valid =
          _formKeyStep2.currentState!.validate() &&
          _selectedSubjects.isNotEmpty &&
          _selectedEducationCycle.isNotEmpty;

      if (!valid) {
        _showSnackBar("Veuillez remplir tous les champs requis", isError: true);
        return;
      }
    }

    if (_currentStep < _steps().length - 1) {
      setState(() => _currentStep++);
    } else {
      _submitTeacherProfile();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Future<void> _submitTeacherProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_profileImageFile != null) {
        imageUrl = await _storageService.uploadSchoolImage(
          'teachers',
          widget.initialUser.id,
          widget.initialUser.name,
          _profileImageFile!,
        );
      }

      final teacher = TeacherModel(
        id: widget.initialUser.id,
        name: '${_firstNameController.text} ${_lastNameController.text}',
        email: widget.initialUser.email ?? '',
        role: 'teacher',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        department: _departmentController.text,
        country: 'Congo-Brazzaville',
        diplomaUrl: '',
        diplomas: _selectedDiploma != null ? [_selectedDiploma!] : [],
        yearsOfExperience: _yearsOfExperience ?? 0,
        educationCycles: _selectedEducationCycle.toList(),
        subjects: _selectedSubjects.toList(),
        languages: ['français'],
        isAvailable: true,
        isInspector: false,
        createdAt: DateTime.now(),
        bio: '',
        workshopParticipationCount: 0,
        profileImageUrl: imageUrl ?? _selectedImageUrl,
        isCivilServant: false,
      );

      context.read<TeacherBloc>().add(CreateTeacher(teacher));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Erreur: ${e.toString()}", isError: true);
    }
  }

  void _handleImageSelected(File file) {
    setState(() {
      _profileImageFile = file;
      _selectedImageUrl = file.path;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  List<Step> _steps() => [
    Step(
      title: const Text(
        'Informations personnelles',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _formKeyStep1,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ReusableImagePicker(
              imageUrl: _selectedImageUrl,
              onImageSelected: _handleImageSelected,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _firstNameController,
              label: 'Prénom*',
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _lastNameController,
              label: 'Nom*',
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 15),
            CustomTextFormFieldPhone(
              phoneNumberController: _phoneNumberController,
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _departmentController,
              label: 'Département*',
              prefixIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(height: 15),
            CustomDropdownButton(
              title: 'Genre',
              listes: ListesApp.genders,
              selectedItem: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value),
              prefixIcon: const Icon(Icons.transgender),
            ),
          ],
        ),
      ),
    ),
    Step(
      title: const Text(
        'Informations professionnelles',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _formKeyStep2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Matières*',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              CustomWrapSelected(
                childrenList: ListesApp.subjects,
                onSelected:
                    (selected) =>
                        setState(() => _selectedSubjects = selected.toSet()),
              ),
              const SizedBox(height: 20),
              const Text(
                'Niveaux*',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              CustomWrapSelected(
                childrenList: ListesApp.levels,
                onSelected:
                    (selected) => setState(
                      () => _selectedEducationCycle = selected.toSet(),
                    ),
              ),
              const SizedBox(height: 20),
              CustomDropdownButton(
                title: "Niveau d'études",
                listes: ListesApp.diplomas,
                selectedItem: _selectedDiploma,
                onChanged: (value) => setState(() => _selectedDiploma = value),
                prefixIcon: const Icon(Icons.school),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Années d'expérience*",
                  suffixText: 'ans',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  final number = int.tryParse(value);
                  return number == null ? 'Entrée invalide' : null;
                },
                onChanged: (value) => _yearsOfExperience = int.tryParse(value),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherLoaded) {
          setState(() {
            _isLoading = false;
          });
          _showSnackBar("Profil enseignant créé avec succès!");
          context.read<AuthBloc>().add(const MarkUserAsRegistered());
          context.go('/home');
        } else if (state is TeacherError) {
          setState(() {
            _isLoading = false;
          });
          _showSnackBar(state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Création Profil Enseignant'),
          centerTitle: true,
          elevation: 4,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Couleur des en-têtes des étapes
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepCancel: _onStepCancel,
            controlsBuilder:
                (context, details) => Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: details.onStepCancel,
                        child: const Text(
                          'Retour',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: _isLoading ? null : details.onStepContinue,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  _currentStep == _steps().length - 1
                                      ? 'Terminer'
                                      : 'Suivant',
                                  style: const TextStyle(color: Colors.white),
                                ),
                      ),
                    ],
                  ),
                ),
            steps: _steps(),
          ),
        ),
      ),
    );
  }
}
