import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/job/presentation/bloc/bloc/joboffer_event.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/school/presentation/bloc/bloc/school_event.dart';

import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/joboffer_bloc.dart';
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
    // final school = context.read<SchoolBloc>().add(LoadSchools as SchoolEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobOfferBloc, JobOfferState>(
      builder: (context, state) {
        if (state is JobOffersLoaded) {
          final offers = state.offers;

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final currentUser =
                  authState is Authenticated ? authState.user : null;
              final isSchool = widget.role == 'ecole';

              if (offers.isEmpty) {
                return Scaffold(body: Center(child: Text("Aucunne donnee ")));
              }

              return ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  final canEdit = isSchool && offer.schoolId == currentUser?.id;
                  // final formattedDate = DateFormat('dd/MM/yyyy').format(offer.date);

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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.title),
                          const SizedBox(height: 4),
                          Text(
                            offer.description.length > 50
                                ? '${offer.description.substring(0, 50)}...'
                                : offer.description,
                          ),
                          const SizedBox(height: 4),
                          // Text('Publié le $formattedDate',
                          //   style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      leading: const Icon(Icons.work, size: 32),
                      onTap: () => context.push('/offer-details', extra: offer),
                      trailing:
                          canEdit
                              ? IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => context.push(
                                      '/edit-offer',
                                      extra: offer,
                                    ),
                              )
                              : null,
                    ),
                  );
                },
              );
            },
          );
        } else if (state is JobOfferError) {
          return Center(child: Text('Erreur: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

//
