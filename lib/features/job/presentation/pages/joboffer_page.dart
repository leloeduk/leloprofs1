import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/joboffer_bloc.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobofferPage extends StatefulWidget {
  final String role;
  const JobofferPage({super.key, required this.role});

  @override
  State<JobofferPage> createState() => _JobofferPageState();
}

class _JobofferPageState extends State<JobofferPage> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;

      if (user.role == 'ecole') {
        context.read<JobOfferBloc>().add(
          LoadJobOffers(user.id, schoolUid: user.id),
        );
      } else {
        context.read<JobOfferBloc>().add(
          LoadJobOffers('all', schoolUid: 'public'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<JobOfferBloc, JobOfferState>(
        builder: (context, state) {
          if (state is JobOfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobOffersLoaded) {
            final offers = state.offers;

            if (offers.isEmpty) {
              return const Center(child: Text("Aucune offre disponible"));
            }

            return ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      offer.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Text(
                      offer.description.length > 50
                          ? '${offer.description.substring(0, 50)}...'
                          : offer.description,
                    ),
                    leading: const Icon(Icons.work, size: 32),
                    onTap: () => context.push('/offer-details', extra: offer),
                  ),
                );
              },
            );
          } else if (state is JobOfferError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }

          // Par défaut, on affiche un loader
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
