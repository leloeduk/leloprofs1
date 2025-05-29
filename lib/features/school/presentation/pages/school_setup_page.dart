import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/domain/entities/user_model.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_event.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_state.dart';

class SchoolSetupPage extends StatefulWidget {
  final UserModel initialUser;
  const SchoolSetupPage({super.key, required this.initialUser});

  @override
  State<SchoolSetupPage> createState() => _SchoolSetupPageState();
}

class _SchoolSetupPageState extends State<SchoolSetupPage> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Contrôleurs pour les champs
  final _schoolNameController = TextEditingController();
  final _townController = TextEditingController();
  final _departmentController = TextEditingController();
  final _countryController = TextEditingController();
  final _primaryPhoneController = TextEditingController();

  // Variables pour les sélections
  final Set<String> _selectedSchoolTypes = {};
  final Set<String> _selectedEducationCycles = {};
  String? _selectedYearOfEstablishment;

  @override
  void initState() {
    super.initState();
    _schoolNameController.text = widget.initialUser.name ?? '';
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _townController.dispose();
    _departmentController.dispose();
    _countryController.dispose();
    _primaryPhoneController.dispose();
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

    final schoolData = SchoolModel(
      id: widget.initialUser.id,
      name: _schoolNameController.text.trim(),
      email: widget.initialUser.email,
      role: 'school',
      town: _townController.text.trim(),
      department: _departmentController.text.trim(),
      country: _countryController.text.trim(),
      primaryPhone: _primaryPhoneController.text.trim(),
      isActive: true,
      isVerified: false,
      createdAt: DateTime.now(),
      creationSource: 'app_setup',
      yearOfEstablishment:
          _selectedYearOfEstablishment != null
              ? int.parse(_selectedYearOfEstablishment!)
              : DateTime.now().year,
      jobPosts: [],
      types: _selectedSchoolTypes.toList(),
      educationCycle: _selectedEducationCycles.toList(),
      secondaryPhone: null,
      emergencyPhone: null,
      schoolCreationDate: null,
      ratings: null,
      bio: null,
    );

    context.read<SchoolBloc>().add(CreateSchool(schoolData));
  }

  List<Step> _steps() {
    return [
      // Étape 1: Informations de base
      Step(
        title: const Text('Informations de base'),
        content: Form(
          key: _formKeyStep1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _schoolNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'établissement*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _townController,
                  decoration: const InputDecoration(
                    labelText: 'Ville*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
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
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Pays*',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _primaryPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone principal*',
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
              ],
            ),
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),

      // Étape 2: Informations supplémentaires
      Step(
        title: const Text('Informations supplémentaires'),
        content: Form(
          key: _formKeyStep2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Type d\'établissement*',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'Primaire',
                        'Secondaire',
                        'Collège',
                        'Lycée',
                        'Université',
                        'Professionnel',
                        'Technique',
                      ].map((type) {
                        return FilterChip(
                          label: Text(type),
                          selected: _selectedSchoolTypes.contains(type),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSchoolTypes.add(type);
                              } else {
                                _selectedSchoolTypes.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                if (_selectedSchoolTypes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sélectionnez au moins un type',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),
                const Text(
                  'Cycles éducatifs proposés*',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'Maternelle',
                        'Primaire',
                        'Collège',
                        'Lycée',
                        'Supérieur',
                      ].map((cycle) {
                        return FilterChip(
                          label: Text(cycle),
                          selected: _selectedEducationCycles.contains(cycle),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedEducationCycles.add(cycle);
                              } else {
                                _selectedEducationCycles.remove(cycle);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                if (_selectedEducationCycles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Sélectionnez au moins un cycle',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Année de création*",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedYearOfEstablishment,
                  validator:
                      (value) =>
                          value == null ? 'Ce champ est obligatoire' : null,
                  items: List.generate(
                    50,
                    (index) => DropdownMenuItem(
                      value: (DateTime.now().year - index).toString(),
                      child: Text((DateTime.now().year - index).toString()),
                    ),
                  ),
                  onChanged:
                      (value) =>
                          setState(() => _selectedYearOfEstablishment = value),
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
    return BlocListener<SchoolBloc, SchoolState>(
      listener: (context, state) {
        if (state is SchoolLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil école créé avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AuthBloc>().add(const MarkUserAsRegistered());
          context.go('/home');
        } else if (state is SchoolError) {
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
          title: const Text('Configuration du profil école'),
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
