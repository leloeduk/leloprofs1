// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../domain/models/joboffer_model.dart';
// import '../bloc/bloc/joboffer_bloc.dart';

// class CreateJobOfferPage extends StatefulWidget {
//   const CreateJobOfferPage({super.key});

//   @override
//   State<CreateJobOfferPage> createState() => _CreateJobOfferPageState();
// }

// class _CreateJobOfferPageState extends State<CreateJobOfferPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   ContractType? _contractType;
//   SchoolLevel? _schoolLevel;

//   void _submit() {
//     if (_formKey.currentState?.validate() ?? false) {
//       final newOffer = JobOfferModel(
//         jobId: '',// sera généré en base
//         title: _titleController.text,
//         description: _descriptionController.text,
//         contractType: _contractType ?? ContractType.fullTime,
//         schoolLevel: _schoolLevel ?? SchoolLevel.university,
//         schoolId: ,
//         schoolName: 'Nom de l\'école',
//         schoolCity: 'Ville',
//         schoolCountry: 'Pays',
        
//          creationDate: DateTime.now(),
//           schoolAddress: '',
       
//         // etc...
//       );

//     context.read<JobOfferBloc>().add((newOffer));

//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Créer une offre')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Titre'),
//                 validator: (value) => value == null || value.isEmpty ? 'Le titre est requis' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 5,
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 validator: (value) => value == null || value.isEmpty ? 'La description est requise' : null,
//               ),
//               DropdownButtonFormField<ContractType>(
//                 value: _contractType,
//                 decoration: const InputDecoration(labelText: 'Type de contrat'),
//                 items: ContractType.values
//                     .map((e) => DropdownMenuItem(
//                           value: e,
//                           child: Text(e.name),
//                         ))
//                     .toList(),
//                 onChanged: (v) => setState(() => _contractType = v),
//                 validator: (v) => v == null ? 'Le type de contrat est requis' : null,
//               ),
//               DropdownButtonFormField<SchoolLevel>(
//                 value: _schoolLevel,
//                 decoration: const InputDecoration(labelText: 'Niveau scolaire'),
//                 items: SchoolLevel.values
//                     .map((e) => DropdownMenuItem(
//                           value: e,
//                           child: Text(e.name),
//                         ))
//                     .toList(),
//                 onChanged: (v) => setState(() => _schoolLevel = v),
//                 validator: (v) => v == null ? 'Le niveau scolaire est requis' : null,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text('Créer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
