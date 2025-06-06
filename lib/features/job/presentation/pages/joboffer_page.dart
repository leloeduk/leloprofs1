import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';
import '../bloc/bloc/joboffer_bloc.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobOfferPage extends StatefulWidget {
  final String role;
  const JobOfferPage({super.key, required this.role});

  @override
  State<JobOfferPage> createState() => _JobOfferPageState();
}

class _JobOfferPageState extends State<JobOfferPage> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      if (user.role == 'ecole') {
        context.read<JobOfferBloc>().add(LoadJobOffers(user.id));
      } else {
        context.read<JobOfferBloc>().add(LoadJobOffers());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Imports et AppBar inchangés
      body: BlocBuilder<JobOfferBloc, JobOfferState>(
        builder: (context, state) {
          print('Current state: $state');
          print('Number of offers: ${state.props.length}');

          if (state is JobOfferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobOfferLoaded) {
            print(state);
            print(state.offers);
            if (state.offers.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune offre disponible.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.offers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final offer = state.offers[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/offer-details', extra: offer);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.work_outline,
                                color: Colors.red.shade400,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  offer.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.school,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  offer.schoolName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  offer.schoolCity,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${offer.monthlySalary}€ / mois',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  offer.schoolLevel.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is JobOfferError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Erreur inconnue'));
        },
      ),
    );
  }
}
