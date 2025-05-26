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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _departmentController = TextEditingController();
  // Ajoutez d'autres contrôleurs pour les champs nécessaires

  @override
  void initState() {
    super.initState();
    // Pré-remplir le nom si possible, bien que le nom Google soit souvent complet
    // Vous pouvez choisir de le laisser vide ou de tenter une séparation
    // _firstNameController.text = widget.initialUser.name.split(' ').firstOrNull ?? '';
    // _lastNameController.text = widget.initialUser.name.split(' ').skip(1).join(' ');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _departmentController.dispose();
    // Disposez les autres contrôleurs
    super.dispose();
  }

  void _onStepContinue() {
    final isLastStep = _currentStep == _steps().length - 1;
    if (isLastStep) {
      // Valider le formulaire de la dernière étape
      // if (_formKeyStepN.currentState!.validate()) {
      //   _completeProfile();
      // }
      _completeProfile(); // Pour l'exemple, on appelle directement
    } else {
      // Valider le formulaire de l'étape actuelle avant de continuer
      // Exemple pour la première étape :
      if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else if (_currentStep != 0) {
        // Pour les autres étapes, ajoutez des clés de formulaire
        setState(() => _currentStep += 1);
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      context.pop(); // Revenir à la page de sélection de rôle
    }
  }

  void _completeProfile() {
    // Assurez-vous que tous les formulaires sont valides si vous avez plusieurs formulaires
    if (!_formKeyStep1.currentState!.validate())
      return; // Exemple pour la première étape

    final teacherData = TeacherModel(
      id: widget.initialUser.id,
      name:
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}', // Nom complet
      email: widget.initialUser.email,
      role: 'teacher',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      department: _departmentController.text.trim(),
      country: '', // À collecter
      diplomas: [], // À collecter
      yearsOfExperience: 0, // À collecter
      educationCycles: [], // À collecter
      subjects: [], // À collecter
      languages: [], // À collecter
      isAvailable: true,
      isInspector: false,
      createdAt: DateTime.now(),
      // teacherSince: null, // Laissez les valeurs par défaut ou collectez-les
      // lastAvailabilityUpdate: null,
    );

    context.read<TeacherBloc>().add(CreateTeacher(teacherData));
  }

  List<Step> _steps() {
    return [
      Step(
        title: const Text('Informations Personnelles'),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom de famille'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Département/Région',
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              // Ajoutez d'autres champs ici (pays, etc.)
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Détails Professionnels'),
        content: Column(
          children: const [
            // Ajoutez ici les champs pour les diplômes, expérience, matières, langues, etc.
            // Utilisez des widgets appropriés (TextFormField, DropdownButton, ChipInput, etc.)
            Text(
              'Section pour les diplômes, années d\'expérience, matières, etc.',
            ),
            Text('Cette section est à développer avec les champs adéquats.'),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      // Ajoutez d'autres étapes si nécessaire
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
              content: Text('Erreur lors de la création: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Configurer Profil Enseignant')),
        body: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepCancel: _onStepCancel,
          steps: _steps(),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep = _currentStep == _steps().length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'TERMINER' : 'CONTINUER'),
                  ),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('RETOUR'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
