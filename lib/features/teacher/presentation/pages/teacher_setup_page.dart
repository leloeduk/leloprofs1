import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Contrôleurs pour les champs
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();

  // Variables pour les sélections
  String? _selectedGender;
  final Set<String> _selectedSubjects = {};
  final Set<String> _selectedEducationCycle = {};
  String? _selectedDiploma;
  int? _yearsOfExperience;
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Pré-remplir l'email si disponible
    final nameParts = widget.initialUser.name!.split(' ');
    _firstNameController.text = nameParts.first;
    if (nameParts.length > 1) {
      _lastNameController.text = nameParts.sublist(1).join(' ');
    }
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
    switch (_currentStep) {
      case 0:
        if (!_formKeyStep1.currentState!.validate()) return;
        break;
      case 1:
        if (!_formKeyStep2.currentState!.validate()) return;
        break;
    }

    if (_currentStep < _steps().length - 1) {
      setState(() => _currentStep += 1);
    } else {
      _completeProfile();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      context.pop();
    }
  }

  void _completeProfile() {
    if (!_formKeyStep1.currentState!.validate() ||
        !_formKeyStep2.currentState!.validate()) {
      return;
    }

    final teacherData = TeacherModel(
      id: widget.initialUser.id,
      name:
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      email: widget.initialUser.email,
      role: 'teacher',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      department: _departmentController.text.trim(),
      // gender: _selectedGender,
      country: 'Congo-Brazzaville',
      diplomaUrl: "", //
      diplomas: _selectedDiploma != null ? [_selectedDiploma!] : [],
      yearsOfExperience: _yearsOfExperience ?? 0,
      educationCycles: _selectedEducationCycle.toList(),
      subjects: _selectedSubjects.toList(),
      languages: ["français"], // À implémenter
      isAvailable: true,
      isInspector: false,
      createdAt: DateTime.now(),
      bio: '',
      workshopParticipationCount: 0,
      profileImageUrl: _selectedImage,

      isCivilServant: false,
    );

    context.read<TeacherBloc>().add(CreateTeacher(teacherData));
  }

  List<Step> _steps() {
    return [
      // Étape 1: Informations personnelles
      Step(
        title: const Text('Informations Personnelles'),
        content: Form(
          key: _formKeyStep1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReusableImagePicker(
                  initialImageFile: null, // ou une File existante
                  imageUrl: _selectedImage,
                  onImageSelected: (file) {
                    // Enregistre ou envoie l'image sélectionnée
                    print("Image sélectionnée : ${file.path}");
                  },
                ),

                CustomTextField(
                  controller: _firstNameController,
                  label: "Prénom*",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _lastNameController,
                  label: "Nom de famille*",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _firstNameController,
                  label: "Prénom*",
                ),
                const SizedBox(height: 16),
                CustomTextFormFieldPhone(
                  phoneNumberController: _phoneNumberController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _departmentController,
                  label: "Département/Région*",
                ),
                const SizedBox(height: 16),

                CustomDropdownButton(
                  title: "Votre genre",
                  listes: ListesApp.genders,
                  selectedItem: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),

      // Étape 2: Informations professionnelles
      Step(
        title: const Text('Informations Professionnelles'),
        content: Form(
          key: _formKeyStep2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Matières enseignées*',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomWrapSelected(childrenList: ListesApp.subjets),
                if (_selectedSubjects.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sélectionnez au moins une matière',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),
                CustomWrapSelected(childrenList: ListesApp.levels),
                if (_selectedEducationCycle.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sélectionnez au moins une matière',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 16),
                CustomDropdownButton(
                  title: "Votre genre",
                  listes: ListesApp.genders,
                  selectedItem: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                CustomDropdownButton(
                  title: "Votre niveau d'études",
                  listes: ListesApp.diplomas,
                  selectedItem: _selectedDiploma,
                  onChanged: (value) {
                    setState(() {
                      _selectedDiploma = value;
                    });
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Années d'expérience*",
                    border: OutlineInputBorder(),
                    suffixText: 'ans',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ce champ est obligatoire';
                    if (int.tryParse(value) == null) {
                      return 'Entrez un nombre valide';
                    }
                    return null;
                  },
                  onChanged:
                      (value) => _yearsOfExperience = int.tryParse(value),
                ),
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil enseignant créé avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AuthBloc>().add(const MarkUserAsRegistered());
          context.go('/home');
        } else if (state is TeacherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Créer un profil enseignant'),
          centerTitle: true,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepCancel: _onStepCancel,
            steps: _steps(),
            controlsBuilder: (context, details) {
              final isLastStep = _currentStep == _steps().length - 1;
              return Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('RETOUR'),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(isLastStep ? 'TERMINER' : 'SUIVANT'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
