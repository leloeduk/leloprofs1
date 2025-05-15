import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/joboffer_bloc.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobOffersPage extends StatelessWidget {
  const JobOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les offres d'emploi dès l'ouverture de la page
    context.read<JobOfferBloc>().add(LoadJobOffers());

    return Scaffold(
      body: BlocBuilder<JobOfferBloc, JobOfferState>(
        builder: (context, state) {
          if (state is JobOfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobOfferError) {
            return Center(child: Text(state.message));
          } else if (state is JobOfferLoaded) {
            final jobOffers = state.jobOffers;

            if (jobOffers.isEmpty) {
              return const Center(child: Text("Aucune offre disponible."));
            }

            return ListView.builder(
              itemCount: jobOffers.length,
              itemBuilder: (context, index) {
                final job = jobOffers[index];

                return ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: Text(job.title ?? 'Titre inconnu'),
                  subtitle: Text(
                    '${job.title ?? 'École inconnue'} • ${job.description ?? ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<JobOfferBloc>().add(DeleteJobOffer(job.id));
                    },
                  ),
                  onTap: () {
                    // Action sur le tap (ex: voir détails, postuler, modifier)
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("État inconnu."));
          }
        },
      ),
    );
  }
}
