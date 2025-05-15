// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
// import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_event.dart';

// import '../../../school/data/datasources/firebase_school_data_source';
// import '../../../school/data/models/school_model.dart';
// import '../../../teacher/data/models/teacher_model.dart';
// import '../../../teacher/data/repositories/teacher_repository_impl.dart';

// class AccountTypeSelectionPage extends StatefulWidget {
//   const AccountTypeSelectionPage({super.key});

//   @override
//   State<AccountTypeSelectionPage> createState() =>
//       _AccountTypeSelectionPageState();
// }

// class _AccountTypeSelectionPageState extends State<AccountTypeSelectionPage> {
//   String? selectedAccountType;
//   bool _isLoading = false;

//   final teacherRepo = TeacherRepositoryImpl(firestore: FirebaseFirestore.instance);
//   final schoolDataSource = FirebaseSchoolDataSource(firestore: FirebaseFirestore.instance);

//   Future<void> _submit() async {
//     if (selectedAccountType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Veuillez choisir un type de compte.'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Envoi de l'event BLoC pour mettre à jour le type de compte
//       context.read<AuthBloc>().add(UpdateAccountType(selectedAccountType!));

//       await createAccountForType(selectedAccountType!);

//       // Après création / login, naviguer vers l'accueil
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Erreur lors de la création du compte: $e'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> createAccountForType(String type) async {
//     if (type == 'teacher') {
//       // Crée un objet Teacher avec les infos nécessaires (exemple simple)
//       TeacherModel newTeacher = TeacherModel(
//         id: '', // Laisse Firestore générer l'id si tu utilises .add() dans ton repo
//         name: 'Nom par défaut', // Remplace par les vraies données utilisateur
//         // ... autres champs obligatoires initialisés
//       );

//       await teacherRepo.createTeacher(newTeacher);
//       print('Compte Enseignant créé');
//     } else if (type == 'school') {
//       SchoolModel newSchool = SchoolModel(
//         id: '', // pareil, laisse Firestore gérer l'id si possible
//         name: 'Nom École par défaut',
//         // ... autres champs obligatoires initialisés
//       );

//       await schoolDataSource.createSchool(newSchool);
//       print('Compte École créé');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Choisir un type de compte')),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Quel type de compte souhaitez-vous créer ?',
//               style: textTheme.titleMedium,
//             ),
//             const SizedBox(height: 24),

//             GestureDetector(
//               onTap: () => setState(() => selectedAccountType = 'teacher'),
//               child: Card(
//                 color: selectedAccountType == 'teacher'
//                     ? Colors.red.shade100
//                     : Colors.white,
//                 elevation: selectedAccountType == 'teacher' ? 8 : 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(
//                     color: selectedAccountType == 'teacher'
//                         ? Colors.red
//                         : Colors.grey.shade300,
//                     width: 2,
//                   ),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.person,
//                     color: selectedAccountType == 'teacher'
//                         ? Colors.red
//                         : Colors.grey,
//                   ),
//                   title: Text('Enseignant',
//                       style: TextStyle(
//                         color: selectedAccountType == 'teacher'
//                             ? Colors.red
//                             : Colors.black,
//                         fontWeight: FontWeight.w600,
//                       )),
//                   trailing: selectedAccountType == 'teacher'
//                       ? const Icon(Icons.check_circle, color: Colors.red)
//                       : null,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             GestureDetector(
//               onTap: () => setState(() => selectedAccountType = 'school'),
//               child: Card(
//                 color: selectedAccountType == 'school'
//                     ? Colors.red.shade100
//                     : Colors.white,
//                 elevation: selectedAccountType == 'school' ? 8 : 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(
//                     color: selectedAccountType == 'school'
//                         ? Colors.red
//                         : Colors.grey.shade300,
//                     width: 2,
//                   ),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.school,
//                     color: selectedAccountType == 'school'
//                         ? Colors.red
//                         : Colors.grey,
//                   ),
//                   title: Text('École',
//                       style: TextStyle(
//                         color: selectedAccountType == 'school'
//                             ? Colors.red
//                             : Colors.black,
//                         fontWeight: FontWeight.w600,
//                       )),
//                   trailing: selectedAccountType == 'school'
//                       ? const Icon(Icons.check_circle, color: Colors.red)
//                       : null,
//                 ),
//               ),
//             ),

//             const Spacer(),

//             ElevatedButton(
//               onPressed: (_isLoading || selectedAccountType == null) ? null : _submit,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: selectedAccountType == null
//                     ? Colors.grey
//                     : Colors.red,
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Valider'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
