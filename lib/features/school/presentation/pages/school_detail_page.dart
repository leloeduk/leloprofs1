import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/job/domain/models/joboffer_model.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';

class SchoolDetailPage extends StatefulWidget {
  final SchoolModel school;
  final String currentUserId;

  const SchoolDetailPage({
    super.key,
    required this.school,
    required this.currentUserId,
  });

  @override
  State<SchoolDetailPage> createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
  late final JobOfferModel offer;

  @override
  void initState() {
    offer = JobOfferModel(
      id: '', // À générer plus tard
      title: '',
      description: '',
      schoolId: widget.school.id,
      schoolName: widget.school.name,
      schoolLogo: widget.school.profileImageUrl,
      contractType: '',
      domain: '', // ou widget.school.domain si disponible
      location: widget.school.town,
      salary: 0.0,
      hoursPerWeek: 0,
      date: DateTime.now(),
      // department: widget.school.department,
      // educationCycle: widget.school.educationCycle.isNotEmpty
      //     ? widget.school.educationCycle.first
      //     : '',
      // subject: '',
      // language: '',
      // isRemote: false,
      // isActive: true,
      // createdAt: DateTime.now(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final bool canEdit = widget.school.id == widget.currentUserId;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: color.primary,
            foregroundColor: color.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.school.profileImageUrl != null
                      ? Image.network(
                        widget.school.profileImageUrl!,
                        fit: BoxFit.cover,
                      )
                      : Container(color: color.primary),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      widget.school.name,
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.edit, size: 50),
                  onPressed:
                      () => context.pushNamed(
                        'edit-school',
                        extra: widget.school,
                      ),
                ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: color.secondary,
                    backgroundImage:
                        widget.school.profileImageUrl != null
                            ? NetworkImage(widget.school.profileImageUrl!)
                            : null,
                    child:
                        widget.school.profileImageUrl == null
                            ? Icon(
                              Icons.school,
                              size: 40,
                              color: color.onSecondary,
                            )
                            : null,
                  ),
                  const SizedBox(height: 16),
                  Chip(
                    backgroundColor:
                        widget.school.isVerified
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                    label: Text(
                      widget.school.isVerified
                          ? '✅ École Vérifiée'
                          : '❌ Non Vérifiée',
                      style: TextStyle(
                        color:
                            widget.school.isVerified
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 32),
                  _buildSectionTitle(context, 'Informations Générales'),
                  _buildInfoItem(
                    context,
                    Icons.location_city,
                    'Ville',
                    widget.school.town,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.phone,
                    'Téléphone',
                    widget.school.primaryPhone,
                  ),
                  if (widget.school.secondaryPhone != null)
                    _buildInfoItem(
                      context,
                      Icons.phone_android,
                      'Téléphone secondaire',
                      widget.school.secondaryPhone!,
                    ),
                  if (widget.school.country != null)
                    _buildInfoItem(
                      context,
                      Icons.flag,
                      'Pays',
                      widget.school.country!,
                    ),
                  _buildInfoItem(
                    context,
                    Icons.school,
                    'Département',
                    widget.school.department,
                  ),
                  _buildInfoItem(
                    context,
                    Icons.calendar_today,
                    'Créée en',
                    '${widget.school.yearOfEstablishment}',
                  ),

                  const Divider(height: 32),
                  _buildSectionTitle(context, 'Détails Éducatifs'),
                  _buildInfoItem(
                    context,
                    Icons.book_outlined,
                    'Cycles éducatifs',
                    widget.school.educationCycle.join(", "),
                  ),
                  _buildInfoItem(
                    context,
                    Icons.campaign_outlined,
                    'Annonces publiées',
                    widget.school.jobPosts.join(", "),
                  ),
                  if (canEdit)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await context.pushNamed(
                              'edit-offer', //  correspond à name: 'edit-offer'
                              extra:
                                  offer, //  on passe l’objet JobOfferModel en extra
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter une offre'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),

                  if (widget.school.bio != null &&
                      widget.school.bio!.isNotEmpty)
                    _buildInfoItem(
                      context,
                      Icons.description_outlined,
                      'À propos',
                      widget.school.bio!,
                    ),

                  const Divider(height: 32),
                  _buildSectionTitle(context, 'Statut'),
                  _buildInfoItem(
                    context,
                    Icons.verified_user_outlined,
                    'Statut',
                    widget.school.isActive ? 'Actif' : 'Inactif',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: color.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: color.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
