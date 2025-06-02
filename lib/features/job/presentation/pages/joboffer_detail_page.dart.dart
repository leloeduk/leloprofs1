import 'package:flutter/material.dart';

import '../../domain/models/joboffer_model.dart';

class JobOfferDetailPage extends StatefulWidget {
  final JobOfferModel offer;

  const JobOfferDetailPage({super.key, required this.offer});

  @override
  State<JobOfferDetailPage> createState() => _JobOfferDetailPageState();
}

class _JobOfferDetailPageState extends State<JobOfferDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade900,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade800,
            elevation: 8,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadowColor: Colors.grey,
          ),
          icon: const Icon(Icons.send_rounded, size: 22),
          label: const Text(
            'POSTULER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.2,
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            // TODO: Ajouter action postuler
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(opacity: _fadeAnimation.value, child: child);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 203, 17, 17),
                          Color.fromARGB(255, 250, 44, 44),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage:
                            offer.schoolLogoUrl != null
                                ? NetworkImage(offer.schoolLogoUrl!)
                                : null,
                        child:
                            offer.schoolLogoUrl == null
                                ? const Icon(
                                  Icons.school,
                                  size: 60,
                                  color: Colors.redAccent,
                                )
                                : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(padding: const EdgeInsets.only(top: 60)),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    offer.schoolName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.redAccent,
                      letterSpacing: 0.9,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${offer.schoolCity}, ${offer.schoolCountry}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoCard(
                  title: 'DESCRIPTION',
                  child: Text(
                    offer.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                _buildInfoCard(
                  title: 'DÉTAILS DU POSTE',
                  child: Column(
                    children: [
                      _buildDetailRow(
                        Icons.work_outline,
                        'Type de contrat',
                        offer.contractType.name,
                      ),
                      _buildDetailRow(
                        Icons.school_outlined,
                        'Niveau scolaire',
                        offer.schoolLevel.name,
                      ),
                      if (offer.teachingDomain != null)
                        _buildDetailRow(
                          Icons.category_outlined,
                          'Domaine',
                          offer.teachingDomain!,
                        ),
                      if (offer.subjects != null)
                        _buildDetailRow(
                          Icons.book_outlined,
                          'Matières',
                          offer.subjects!,
                        ),
                      if (offer.monthlySalary != null)
                        _buildDetailRow(
                          Icons.euro_symbol_outlined,
                          'Salaire',
                          '${offer.monthlySalary} € / mois',
                        ),
                      if (offer.weeklyHours != null)
                        _buildDetailRow(
                          Icons.access_time_outlined,
                          'Heures/semaine',
                          '${offer.weeklyHours}h',
                        ),
                      if (offer.requiredGender != null)
                        _buildDetailRow(
                          Icons.person_outline,
                          'Genre requis',
                          offer.requiredGender!.name,
                        ),
                    ],
                  ),
                ),
                _buildInfoCard(
                  title: 'CONTACT',
                  child: Column(
                    children: [
                      if (offer.contactEmail != null)
                        _buildDetailRow(
                          Icons.email_outlined,
                          'Email',
                          offer.contactEmail!,
                        ),
                      if (offer.contactPhone != null)
                        _buildDetailRow(
                          Icons.phone_outlined,
                          'Téléphone',
                          offer.contactPhone!,
                        ),
                    ],
                  ),
                ),
                _buildInfoCard(
                  title: 'EXIGENCES',
                  child:
                      offer.requirements.isNotEmpty
                          ? Column(
                            children:
                                offer.requirements
                                    .map(
                                      (req) => ListTile(
                                        dense: true,
                                        leading: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          req,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          )
                          : Text(
                            'Aucune exigence spécifiée.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
                _buildInfoCard(
                  title: 'AVANTAGES',
                  child:
                      offer.benefits.isNotEmpty
                          ? Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children:
                                offer.benefits
                                    .map(
                                      (b) => Chip(
                                        label: Text(
                                          b,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        backgroundColor: Colors.blue.shade50,
                                        avatar: const Icon(
                                          Icons.star,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        elevation: 2,
                                        shadowColor: Colors.redAccent
                                            .withOpacity(0.3),
                                      ),
                                    )
                                    .toList(),
                          )
                          : Text(
                            'Aucun avantage mentionné.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
                _buildInfoCard(
                  title: 'DATE LIMITE',
                  child: Text(
                    offer.applicationDeadline != null
                        ? offer.applicationDeadline!.toLocal().toString().split(
                          ' ',
                        )[0]
                        : 'Non spécifiée',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 1.4,
              color: Colors.redAccent.shade700,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.redAccent.shade700, size: 22),
          const SizedBox(width: 14),
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
