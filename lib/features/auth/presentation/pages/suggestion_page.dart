import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leloprof/features/auth/data/datasources/firebase_auth_repos.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
import 'package:leloprof/features/teacher/data/datasources/firebase_teacher_repos.dart';
import 'package:leloprof/utils/widgets/loading_button.dart';

import '../../../teacher/domain/models/teacher_model.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      try {
        TeacherModel? teacher;
        SchoolModel? school;
        await FirebaseFirestore.instance.collection('suggestions').add({
          'message': _controller.text.trim(),
          'email': FirebaseAuthRepos().getCurrentUser()!.email,
          'uid': FirebaseAuthRepos().getCurrentUser()!.id,
          'role':
              FirebaseAuthRepos()
                  .getCurrentUser()!
                  .role, // ignore: unnecessary_null_comparison

          // 'telephone':
          //     // ignore: unnecessary_null_comparison
          //     teacher != null ? teacher!.phoneNumber : school!.primaryPhone,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Merci pour votre suggestion !'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur d'envoi : $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.feedback_outlined,
                      size: 64,
                      color: color.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Partagez votre avis",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Nous lisons chaque suggestion avec attention.",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: color.tertiary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _controller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Votre message...",
                        filled: true,
                        fillColor: color.secondary.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.tertiary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.primary),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Champ obligatoire'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    //        LoadingButton(
                    //   label: "Enregistrer",
                    //   onValidated: _submit,
                    //   isSubmitting: _isSubmitting,
                    //   color: Colors.red,
                    // ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submit,
                        icon:
                            _isSubmitting
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(Icons.send),
                        label: Text(
                          _isSubmitting ? "Envoi..." : "Envoyer",
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: color.primary,
                          foregroundColor: color.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
