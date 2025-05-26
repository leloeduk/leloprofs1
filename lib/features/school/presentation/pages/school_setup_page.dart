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
  final _schoolNameController = TextEditingController();
  final _townController = TextEditingController();
  final _departmentController = TextEditingController();
  final _countryController = TextEditingController();
  final _primaryPhoneController = TextEditingController();
  // Ajoutez d'autres contrôleurs

  @override
  void initState() {
    super.initState();
    _schoolNameController.text =
        widget
            .initialUser
            .name; // Le nom de l'utilisateur Google peut être le nom de l'école
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _townController.dispose();
    _departmentController.dispose();
    _countryController.dispose();
    _primaryPhoneController.dispose();
    // Disposez les autres contrôleurs
    super.dispose();
  }

  void _onStepContinue() {
    final isLastStep = _currentStep == _steps().length - 1;
    if (isLastStep) {
      // if (_formKeyStepN.currentState!.validate()) { // Valider la dernière étape
      //   _completeProfile();
      // }
      _completeProfile(); // Pour l'exemple
    } else {
      if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else if (_currentStep != 0) {
        setState(() => _currentStep += 1);
      }
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
    if (!_formKeyStep1.currentState!.validate()) return;

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
      isVerified: false, // La vérification se fera plus tard
      createdAt: DateTime.now(),
      creationSource: 'app_setup',
      yearOfEstablishment: DateTime.now().year, // À collecter
      jobPosts: [],
      types: [], // À collecter (ex: ['Primaire', 'Secondaire'])
      educationCycle: [], // À collecter
      // secondaryPhone: null,
      // emergencyPhone: null,
      // schoolCreationDate: null,
      // profileImage: null,
      // ratings: null,
      // bio: null,
    );
    context.read<SchoolBloc>().add(CreateSchool(schoolData));
  }

  List<Step> _steps() {
    return [
      Step(
        title: const Text('Informations de l\'École'),
        content: Form(
          key: _formKeyStep1,
          child: Column(
            children: [
              TextFormField(
                controller: _schoolNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'établissement',
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _townController,
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Département/Région',
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Pays'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _primaryPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone principal',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              // Ajoutez d'autres champs (année de création, types d'établissement, cycles, etc.)
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Autres Détails'),
        content: Column(
          children: const [
            Text(
              'Section pour l\'année de création, types d\'établissement, cycles éducatifs, bio, etc.',
            ),
            Text('Cette section est à développer.'),
          ],
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
          // Ou un état plus spécifique comme SchoolProfileCreated
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
              content: Text('Erreur lors de la création: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Configurer Profil École')),
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
