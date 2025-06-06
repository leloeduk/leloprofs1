import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/firebase/firebase_service.dart';
import '../bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_event.dart';
import '../bloc/bloc/auth_state.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    String role,
  ) async {
    final roleNames = {
      'teacher': 'Enseignant',
      'school': 'École',
      'visitor': 'Visiteur',
    };

    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => AlertDialog(
                title: Center(
                  child: Text(
                    'Confirmer le rôle ${roleNames[role]}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                content: Text(
                  role == 'visitor'
                      ? 'Vous aurez un accès limité en tant que visiteur. Confirmez-vous ce choix ?'
                      : 'Vous avez choisi "${roleNames[role]}". Cette action est irréversible. Confirmez-vous ?',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          'Confirmer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _handleRoleSelection(
    BuildContext context,
    String role,
    String nextRoute,
  ) async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final confirmed = await _showConfirmationDialog(context, role);
    if (!confirmed) return;

    try {
      if (role != 'visitor') {
        context.read<AuthBloc>().add(UpdateUserRoleLocally(role));
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          context.go(nextRoute, extra: authState.user);
        }
      } else {
        await FirestoreService.updateUserRole(authState.user.id, "visitor");
        context.read<AuthBloc>().add(UpdateUserRoleLocally(role));
        context.read<AuthBloc>().add(MarkUserAsRegistered());
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          context.go('/home');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required String role,
    required String route,
    bool isOutlined = false,
  }) {
    final backgroundColor = isOutlined ? Colors.white : color;
    final foregroundColor = isOutlined ? color : Colors.white;
    final border =
        isOutlined ? BorderSide(color: color, width: 1.5) : BorderSide.none;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 24, color: foregroundColor),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, color: foregroundColor),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _handleRoleSelection(context, role, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is Authenticated) {
          final user = state.user;

          // Redirection automatique si rôle déjà choisi mais configuration incomplète
          if (user.isNewUser ?? true) {
            if (user.role == 'teacher') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  context.go('/teacher-setup', extra: user);
                }
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (user.role == 'school') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  context.go('/school-setup', extra: user);
                }
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          }

          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 48,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logos/leloprof.png",
                          width: 220,
                          height: 100,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Choisissez votre rôle",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Vous pouvez être un enseignant, un représentant d'école ou un simple visiteur.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 40),
                        _buildRoleButton(
                          context,
                          icon: Icons.person,
                          text: "Je suis un enseignant",
                          color: Colors.red.shade600,
                          role: 'teacher',
                          route: '/teacher-setup',
                        ),
                        const SizedBox(height: 20),
                        _buildRoleButton(
                          context,
                          icon: Icons.school_rounded,
                          text: "Je représente une école",
                          color: Colors.red.shade600,
                          role: 'school',
                          route: '/school-setup',
                        ),
                        const SizedBox(height: 20),
                        _buildRoleButton(
                          context,
                          icon: Icons.visibility_outlined,
                          text: "Je suis un visiteur",
                          color: Colors.grey.shade700,
                          role: 'visitor',
                          route: '/home',
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
