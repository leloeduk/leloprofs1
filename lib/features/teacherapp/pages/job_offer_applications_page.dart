import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobOfferApplicationsPage extends StatelessWidget {
  final String jobId;

  const JobOfferApplicationsPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidatures'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('jobOffers')
                .doc(jobId)
                .collection('applications')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final applications = snapshot.data?.docs ?? [];

          if (applications.isEmpty) {
            return const Center(
              child: Text('Aucune candidature pour cette offre.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final data = applications[index].data() as Map<String, dynamic>;

              return _buildApplicantCard(context, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> data) {
    final String firstName = data['firstName'] ?? '';
    final String lastName = data['lastName'] ?? '';
    final String profileImageUrl = data['profileImageUrl'] ?? '';
    final String department = data['department'] ?? '';
    final List<dynamic> subjects = data['subjects'] ?? [];
    final double? rating =
        (data['rating'] is int)
            ? (data['rating'] as int).toDouble()
            : data['rating']?.toDouble();
    final String teacherId = data['teacherId'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                  child:
                      profileImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        department,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (rating != null)
                  Chip(
                    label: Text('Note: ${rating.toStringAsFixed(1)} ⭐'),
                    backgroundColor: Colors.orange.shade50,
                  ),
                ...subjects.map(
                  (s) => Chip(
                    label: Text(s),
                    backgroundColor: Colors.green.shade50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Naviguer vers le profil de l'enseignant
                    Navigator.pushNamed(
                      context,
                      '/teacher-profile',
                      arguments: teacherId,
                    );
                  },
                  child: const Text('Voir profil'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _contactApplicant(context, firstName, lastName);
                  },
                  child: const Text('Contacter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _contactApplicant(
    BuildContext context,
    String firstName,
    String lastName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contacter $firstName $lastName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Envoyer un email'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Appeler'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Envoyer un message'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
