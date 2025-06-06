import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import necessary models, blocs, and events
import 'package:leloprof/features/school/presentation/bloc/bloc/school_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_bloc.dart';
import 'package:leloprof/features/teacher/presentation/bloc/bloc/teacher_state.dart';
import '../../../../utils/widgets/contact_launch_button.dart';
import '../../../school/presentation/bloc/bloc/school_event.dart';
import '../../../school/presentation/bloc/bloc/school_state.dart';
import '../../../teacher/presentation/bloc/bloc/teacher_event.dart';
import '../../domain/models/joboffer_model.dart';
import '../bloc/bloc/joboffer_bloc.dart';
import '../bloc/bloc/joboffer_event.dart';
import '../bloc/bloc/joboffer_state.dart';

class JobOfferDetailPage extends StatefulWidget {
  final JobOfferModel offer;

  const JobOfferDetailPage({super.key, required this.offer});

  @override
  State<JobOfferDetailPage> createState() => _JobOfferDetailPageState();
}

class _JobOfferDetailPageState extends State<JobOfferDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isApplying = false;
  dynamic school;
  dynamic teacher;
  String? userRole;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    context.read<TeacherBloc>().add(LoadTeachers());
    context.read<SchoolBloc>().add(LoadSchools());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offer = widget.offer;

    return MultiBlocListener(
      listeners: [
        BlocListener<JobOfferBloc, JobOfferState>(
          listener: (context, state) {
            if (state is JobOfferSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              setState(() {
                _isApplying = false;
              });
            } else if (state is JobOfferError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              setState(() => _isApplying = false);
            }
          },
        ),
        BlocListener<SchoolBloc, SchoolState>(
          listener: (context, state) {
            if (state is SchoolLoaded) {
              setState(() {
                school = state.schools.firstWhere(
                  (s) => s.id == widget.offer.schoolId,
                );
                userRole = 'school';
                currentUserId = school?.schoolId;
              });
            }
          },
        ),
        BlocListener<TeacherBloc, TeacherState>(
          listener: (context, state) {
            if (state is TeacherLoaded) {
              setState(() {
                teacher = state.teachers.firstWhere(
                  (t) => t.id == widget.offer.schoolId,
                );
                userRole = 'teacher';
                currentUserId = teacher?.teacherId;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        floatingActionButton: _buildFloatingActionButton(),
        body: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(opacity: _fadeAnimation, child: child);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeaderSection(offer, theme),
              _buildSchoolInfoSection(offer),
              _buildContentSections(offer, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (userRole == 'teacher') {
      return FloatingActionButton.extended(
        backgroundColor: _isApplying ? Colors.grey : Colors.red.shade700,
        elevation: 4,
        icon:
            _isApplying
                ? Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : const Icon(Icons.send, color: Colors.white),
        label: Text(
          _isApplying ? 'ENVOI...' : 'POSTULER',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: _isApplying ? null : _handleApplication,
      );
    } else if (userRole == 'school' && currentUserId == widget.offer.schoolId) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.red.shade800,
        elevation: 4,
        icon: const Icon(Icons.group, color: Colors.white),
        label: const Text(
          'CANDIDATS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/candidates',
            arguments: widget.offer.jobId,
          );
        },
      );
    }
    return null;
  }

  void _handleApplication() {
    context.read<JobOfferBloc>().add(
      ApplyForJob(jobOfferId: widget.offer.jobId),
    );
    setState(() {
      _isApplying = true;
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade900.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  SliverToBoxAdapter _buildHeaderSection(JobOfferModel offer, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade900, Colors.red.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.white,
                backgroundImage:
                    offer.schoolLogoUrl != null
                        ? NetworkImage(offer.schoolLogoUrl!)
                        : null,
                child:
                    offer.schoolLogoUrl == null
                        ? Icon(
                          Icons.school,
                          size: 60,
                          color: theme.colorScheme.primary,
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildSchoolInfoSection(JobOfferModel offer) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 60, bottom: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text(
              offer.schoolName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${offer.schoolCity}, ${offer.schoolCountry}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildContentSections(JobOfferModel offer, ThemeData theme) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildInfoCard(
          title: 'Description du poste',
          child: Text(
            offer.description,
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
        ),
        _buildInfoCard(
          title: 'Détails du poste',
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
                  Icons.menu_book_outlined,
                  'Matières',
                  offer.subjects!,
                ),
              if (offer.monthlySalary != null)
                _buildDetailRow(
                  Icons.payments_outlined,
                  'Salaire mensuel',
                  '${offer.monthlySalary} €',
                ),
              if (offer.weeklyHours != null)
                _buildDetailRow(
                  Icons.access_time_outlined,
                  'Temps de travail',
                  '${offer.weeklyHours}h/semaine',
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
          title: 'Contact',
          child: Column(
            children: [
              if (offer.contactEmail != null)
                _buildDetailRow(
                  Icons.email_outlined,
                  'Email',
                  offer.contactEmail!,
                ),
              if (offer.contactPhone != null) ...[
                _buildDetailRow(
                  Icons.phone_outlined,
                  'Téléphone',
                  offer.contactPhone!,
                ),
                const SizedBox(height: 12),
                ContactLauncherButton(
                  label: "Appeler",
                  contact: "+242${offer.contactPhone}",
                  icon: Icons.phone_android,
                ),
              ],
            ],
          ),
        ),
        _buildInfoCard(
          title: 'Exigences',
          child:
              offer.requirements.isNotEmpty
                  ? Column(
                    children:
                        offer.requirements
                            .map(
                              (req) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                                title: Text(req),
                              ),
                            )
                            .toList(),
                  )
                  : Text(
                    'Aucune exigence spécifique',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
        ),
        _buildInfoCard(
          title: 'Avantages',
          child:
              offer.benefits.isNotEmpty
                  ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        offer.benefits
                            .map(
                              (b) => Chip(
                                label: Text(b),
                                avatar: const Icon(
                                  Icons.star_outline,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                backgroundColor: Colors.amber.shade50,
                              ),
                            )
                            .toList(),
                  )
                  : Text(
                    'Aucun avantage mentionné',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
        ),
        _buildInfoCard(
          title: 'Date limite de candidature',
          child: Text(
            offer.applicationDeadline != null
                ? _formatDate(offer.applicationDeadline!)
                : 'Non spécifiée',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ]),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.1,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
