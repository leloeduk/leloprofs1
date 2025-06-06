import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';
import '../../../school/domain/models/school_model.dart';
import '../bloc/bloc/joboffer_bloc.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobOfferEditPage extends StatefulWidget {
  final JobOfferModel offer;
  final SchoolModel school;

  const JobOfferEditPage({
    super.key,
    required this.offer,
    required this.school,
  });

  @override
  State<JobOfferEditPage> createState() => _JobOfferEditPageState();
}

class _JobOfferEditPageState extends State<JobOfferEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.offer.title);
    _descriptionController = TextEditingController(
      text: widget.offer.description,
    );
    _salaryController = TextEditingController(
      text: widget.offer.monthlySalary.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitOffer() {
    final updatedOffer = widget.offer.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      monthlySalary: double.tryParse(_salaryController.text.trim()) ?? 0.0,
    );

    final bloc = context.read<JobOfferBloc>();
    if (widget.offer.jobId.isEmpty) {
      bloc.add(CreateJobOffer(updatedOffer));
    } else {
      bloc.add(UpdateJobOffer(updatedOffer));
    }

    Navigator.pop(context);
  }

  void _viewApplicants() {
    if (widget.offer.schoolId != widget.school.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cette offre ne appartient pas à votre école'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.offer.applicantIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun enseignant n\'a postulé pour cette offre'),
        ),
      );
      return;
    }

    // Naviguer vers une page qui affiche les enseignants ayant postulé
    // Vous devrez implémenter cette page selon vos besoins
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Candidats')),
              body: ListView.builder(
                itemCount: widget.offer.applicantIds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Enseignant ${index + 1}'),
                    subtitle: Text(widget.offer.applicantIds[index]),
                    // Vous devrez récupérer les détails de l'enseignant ici
                    onTap: () {
                      // Action lorsqu'on clique sur un enseignant
                    },
                  );
                },
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final school = widget.school;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.offer.jobId.isEmpty ? 'Créer une offre' : 'Modifier l\'offre',
        ),
        actions: [
          if (widget.offer.jobId.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.people_alt),
              onPressed: _viewApplicants,
              tooltip: 'Voir les candidats',
            ),
        ],
      ),
      body: BlocBuilder<JobOfferBloc, JobOfferState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// 🏫 Informations sur l'école
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informations de l\'école',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _infoTile(Icons.school, 'École', school.name),
                        _infoTile(
                          Icons.location_city,
                          'Localisation',
                          '${school.town}, ${school.department}',
                        ),
                        _infoTile(
                          Icons.category,
                          'Type',
                          school.types.join(', '),
                        ),
                        _infoTile(
                          Icons.book,
                          'Cycles',
                          school.educationCycle.join(', '),
                        ),
                        _infoTile(
                          Icons.lightbulb,
                          'Approche pédagogique',
                          school.pedagogicalApproach ?? 'Non spécifiée',
                        ),
                        _infoTile(
                          Icons.people,
                          'Enseignants',
                          '${school.teacherCount}',
                        ),
                        _infoTile(
                          Icons.group,
                          'Élèves',
                          '${school.studentCount}',
                        ),
                        if (school.websiteUrl != null)
                          _infoTile(Icons.web, 'Site Web', school.websiteUrl!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                /// 📝 Formulaire d'édition
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Détails de l\'offre',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Titre de l\'offre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Description détaillée',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Salaire ou rémunération',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                /// 🧠 Compétences requises
                const Text(
                  'Compétences et qualifications requises',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      school.diplomas
                          .map(
                            (diploma) => Chip(
                              label: Text(diploma),
                              backgroundColor: Colors.blue[100],
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      school.languages
                          .map(
                            (lang) => Chip(
                              label: Text(lang),
                              backgroundColor: Colors.green[100],
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 24),

                /// ✅ Bouton
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitOffer,
                    icon: const Icon(Icons.send),
                    label: const Text('Publier l\'offre'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
