import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_event.dart';

import '../bloc/bloc/school_bloc.dart';
import '../bloc/bloc/school_state.dart';

class SchoolProfileScreen extends StatelessWidget {
  final String schoolId;

  const SchoolProfileScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil École'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: BlocConsumer<SchoolBloc, SchoolState>(
        listener: (context, state) {
          if (state is DeleteSchool) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(' delleter')));
            // if (state.contains('supprimée')) {
            //   Navigator.pop(context);
            // }
          }
        },
        builder: (context, state) {
          if (state is SchoolLoaded) {
            return Column(
              children: [
                // SchoolInfoCard(school: state.school),
                // AddButton(
                //   onPressed: () => _showAddDialog(context),
                //   label: 'Ajouter Offre',
                // ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final bloc = context.read<SchoolBloc>();
    final school = (bloc.state as SchoolLoaded).schools;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Modifier École'),
            content: Text('nfnfn'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              // TextButton(
              //   onPressed: () {
              //     final updatedSchool = SchoolModel
              //     (uid:,
              //      email: email,
              //      name: name,
              //      town: town, department: department, primaryPhone: primaryPhone, createdAt: createdAt, yearOfEstablishment: yearOfEstablishment)
              //     bloc.add(UpdateSchoolProfile(updatedSchool));
              //     Navigator.pop(context);
              //   },
              //   child: const Text('Enregistrer'),
              // ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer suppression'),
            content: const Text('Voulez-vous vraiment supprimer cette école ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () {
                  context.read<SchoolBloc>().add(DeleteSchool(schoolId));
                  Navigator.pop(context);
                },
                child: const Text('Oui'),
              ),
            ],
          ),
    );
  }
}
