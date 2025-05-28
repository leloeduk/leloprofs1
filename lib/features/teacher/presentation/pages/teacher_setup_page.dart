import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';
import 'package:leloprof/features/teacher/domain/models/teacher_model.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_event.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_state.dart';

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
  String? _selectedEducationCycle;
  String? _selectedDiploma;
  int? _yearsOfExperience;

  @override
  void initState() {
    super.initState();
    // Pré-remplir l'email si disponible
    if (widget.initialUser.name != null) {
      final nameParts = widget.initialUser.name!.split(' ');
      _firstNameController.text = nameParts.first;
      if (nameParts.length > 1) {
        _lastNameController.text = nameParts.sublist(1).join(' ');
      }
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
      country: '', // À implémenter
      diplomas: _selectedDiploma != null ? [_selectedDiploma!] : [],
      yearsOfExperience: _yearsOfExperience ?? 0,
      educationCycles:
          _selectedEducationCycle != null ? [_selectedEducationCycle!] : [],
      subjects: _selectedSubjects.toList(),
      languages: [], // À implémenter
      isAvailable: true,
      isInspector: false,
      createdAt: DateTime.now(),
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
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de famille*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone*',
                    border: OutlineInputBorder(),
                    prefixText: '+',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ce champ est obligatoire';
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Entrez un numéro valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Département/Région*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(value: 'homme', child: Text('Homme')),
                    DropdownMenuItem(value: 'femme', child: Text('Femme')),
                  ],
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'Mathématiques',
                        'Français',
                        'SVT',
                        'Physique-Chimie',
                        'Philosophie',
                        'Informatique',
                        'Histoire-Géographie',
                        'Anglais',
                        'Dessin',
                        'EPS',
                        'Autres',
                      ].map((subject) {
                        return FilterChip(
                          label: Text(subject),
                          selected: _selectedSubjects.contains(subject),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSubjects.add(subject);
                              } else {
                                _selectedSubjects.remove(subject);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                if (_selectedSubjects.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sélectionnez au moins une matière',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Cycle d'enseignement*",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedEducationCycle,
                  validator:
                      (value) =>
                          value == null ? 'Ce champ est obligatoire' : null,
                  items: const [
                    DropdownMenuItem(
                      value: 'Maternelle',
                      child: Text('Maternelle'),
                    ),
                    DropdownMenuItem(
                      value: 'Primaire',
                      child: Text('Primaire'),
                    ),
                    DropdownMenuItem(value: 'Collège', child: Text('Collège')),
                    DropdownMenuItem(value: 'Lycée', child: Text('Lycée')),
                    DropdownMenuItem(
                      value: 'Université',
                      child: Text('Université'),
                    ),
                  ],
                  onChanged:
                      (value) =>
                          setState(() => _selectedEducationCycle = value),
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Niveau d'études*",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDiploma,
                  validator:
                      (value) =>
                          value == null ? 'Ce champ est obligatoire' : null,
                  items: const [
                    DropdownMenuItem(value: 'CEPE', child: Text('CEPE')),
                    DropdownMenuItem(value: 'BEPC', child: Text('BEPC')),
                    DropdownMenuItem(value: 'BAC', child: Text('BAC')),
                    DropdownMenuItem(value: 'BAC +1', child: Text('BAC +1')),
                    DropdownMenuItem(value: 'BAC +2', child: Text('BAC +2')),
                    DropdownMenuItem(value: 'Licence', child: Text('Licence')),
                    DropdownMenuItem(value: 'Master', child: Text('Master')),
                    DropdownMenuItem(
                      value: 'Ingénieur',
                      child: Text('Ingénieur'),
                    ),
                    DropdownMenuItem(
                      value: 'Doctorat',
                      child: Text('Doctorat'),
                    ),
                  ],
                  onChanged:
                      (value) => setState(() => _selectedDiploma = value),
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
                    if (int.tryParse(value) == null)
                      return 'Entrez un nombre valide';
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
          title: const Text('Configuration du profil enseignant'),
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
