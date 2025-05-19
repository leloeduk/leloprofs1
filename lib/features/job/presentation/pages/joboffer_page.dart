import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/job/presentation/bloc/bloc/joboffer_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';

import '../../../school/presentation/bloc/bloc/school_state.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobofferPage extends StatelessWidget {
  const JobofferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offres d\'emploi')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddOfferDialog(context),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SchoolBloc, SchoolState>(
            listener: (context, state) {
              if (state is SchoolIdLoaded) {
                // context.read<JobOfferBloc>().add(
                //   // LoadJobOffers(schoolId: state.schools.uid, schoolUid:state.schools.uid),
                // );
              }
            },
          ),
        ],
        child: BlocBuilder<JobOfferBloc, JobOfferState>(
          builder: (context, state) {
            if (state is JobOfferLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JobOffersLoaded) {
              return ListView.builder(
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  final offer = state.offers[index];
                  return Card(
                    child: ListTile(
                      title: Text(offer.title),
                      subtitle: Text(offer.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDelete(context, offer.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is JobOfferError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Aucune offre disponible'));
          },
        ),
      ),
    );
  }

  void _showAddOfferDialog(BuildContext context) {
    final schoolState = context.read<SchoolBloc>().state;
    final schoolId =
        schoolState is SchoolIdLoaded ? schoolState.schools.uid : null;

    if (schoolId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune école sélectionnée')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Nouvelle offre'),
            content: const TextField(
              decoration: InputDecoration(labelText: 'Titre de l\'offre'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  // Ajouter la logique de création ici
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, String offerId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer suppression'),
            content: const Text('Supprimer cette offre ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  context.read<JobOfferBloc>().add(DeleteJobOffer(offerId));
                  Navigator.pop(context);
                },
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );
  }
}
