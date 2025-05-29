import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';

import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart';

class JobofferEditPage extends StatelessWidget {
  final JobOfferModel offer;

  const JobofferEditPage({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isSchool =
        authState is Authenticated && authState.user.role == 'ecole';
    final isOwner = isSchool && offer.schoolId == authState.user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(offer.title),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/edit-offer', extra: offer),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'École: ${offer.schoolId}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildDetailItem('Type de contrat', offer.id),
            _buildDetailItem('Domaine', offer.title),
            _buildDetailItem('Salaire', '${offer.title} €/mois'),
            _buildDetailItem('Localisation', offer.description),
            const SizedBox(height: 20),
            Text(
              'Description détaillée:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(offer.description),
            ),
            const SizedBox(height: 20),
            if (!isSchool)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _applyToOffer(context),
                  child: const Text('Postuler à cette offre'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }

  void _applyToOffer(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Postuler'),
            content: const Text('Voulez-vous postuler à cette offre ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Candidature envoyée avec succès !'),
                    ),
                  );
                },
                child: const Text('Confirmer'),
              ),
            ],
          ),
    );
  }
}
