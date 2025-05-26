import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/bloc/auth_state.dart'; // Pour les liens externes

class JobOfferDetailPage extends StatelessWidget {
  final JobOfferModel offer;

  const JobOfferDetailPage({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
    // final formattedDate = dateFormat.format(offer.date);
    final theme = Theme.of(context);
    final currentUser =
        context.read<AuthBloc>().state is Authenticated
            ? (context.read<AuthBloc>().state as Authenticated).user
            : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(offer.title),
        actions: [
          if (currentUser?.role == 'ecole' && offer.schoolId == currentUser?.id)
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
            // En-tête avec logo école
            _buildSchoolHeader(context),

            // Section principale
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(offer.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    _buildMetaInfoRow(),
                    const SizedBox(height: 16),
                    _buildDetailSection('Description', offer.description),
                    if (offer.requirements.isNotEmpty)
                      _buildDetailSection(
                        'Compétences requises',
                        offer.requirements.map((r) => '• $r').join('\n'),
                      ),
                    if (offer.benefits.isNotEmpty)
                      _buildDetailSection(
                        'Avantages',
                        offer.benefits.map((b) => '• $b').join('\n'),
                      ),
                  ],
                ),
              ),
            ),

            // Section contact
            _buildContactSection(),

            // Bouton d'action
            if (currentUser?.role == 'enseignant') _buildApplyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              offer.schoolLogo != null ? NetworkImage(offer.schoolLogo!) : null,
          child:
              offer.schoolLogo == null
                  ? Text(offer.schoolName.substring(0, 2))
                  : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.schoolName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Publié le ${DateFormat('dd/MM/yyyy').format(offer.date)}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaInfoRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildMetaChip(Icons.work, offer.contractType),
        _buildMetaChip(Icons.euro, '${offer.salary} €/mois'),
        _buildMetaChip(Icons.location_on, offer.location),
        _buildMetaChip(Icons.schedule, '${offer.hoursPerWeek}h/semaine'),
      ],
    );
  }

  Widget _buildMetaChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(content),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildContactSection() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (offer.contactEmail != null)
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(offer.contactEmail!),
                onTap: () => _launchEmail(offer.contactEmail!),
              ),
            if (offer.contactPhone != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Téléphone'),
                subtitle: Text(offer.contactPhone!),
                onTap: () => _launchPhone(offer.contactPhone!),
              ),
            if (offer.website != null)
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Site web'),
                subtitle: Text(offer.website!),
                onTap: () => _launchUrl(offer.website!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('POSTULER MAINTENANT'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => _showApplyDialog(context),
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Postuler à cette offre'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votre CV et lettre de motivation seront envoyés à :',
                ),
                const SizedBox(height: 8),
                Text(
                  offer.schoolName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Confirmez-vous votre candidature ?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ANNULER'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Candidature envoyée avec succès !'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: const Text('CONFIRMER'),
              ),
            ],
          ),
    );
  }
}
