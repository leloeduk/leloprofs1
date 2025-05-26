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
                title: Text('Confirmer le rôle ${roleNames[role]}'),
                content: Text(
                  role == 'visitor'
                      ? 'Vous aurez un accès limité en tant que visiteur. Confirmez-vous ce choix ?'
                      : 'Vous avez choisi "${roleNames[role]}". Cette action est irréversible. Confirmez-vous ?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Confirmer',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
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
        await FirestoreService.updateUserRole(authState.user.id, role);
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logos/leloprof.png",
                      width: 300,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Quel est votre rôle ?",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Bouton Enseignant
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person, size: 30),
                      label: const Text(
                        "Je suis un enseignant",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          () => _handleRoleSelection(
                            context,
                            'teacher',
                            '/teacher-setup',
                          ),
                    ),
                    const SizedBox(height: 20),
                    // Bouton École
                    ElevatedButton.icon(
                      icon: const Icon(Icons.school, size: 30),
                      label: const Text(
                        "Je représente une école",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          () => _handleRoleSelection(
                            context,
                            'school',
                            '/school-setup',
                          ),
                    ),
                    const SizedBox(height: 20),
                    // Bouton Visiteur
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility, size: 30),
                      label: const Text(
                        "Je suis un visiteur",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          () =>
                              _handleRoleSelection(context, 'visitor', '/home'),
                    ),
                  ],
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
