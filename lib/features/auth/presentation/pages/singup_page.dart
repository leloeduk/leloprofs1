// features/auth/presentation/pages/signup_page.dart
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? email, password;
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value,
                validator: (value) => value!.contains('@')
                    ? null
                    : 'Entrez un email valide',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                onSaved: (value) => password = value,
                validator: (value) => value!.length >= 6
                    ? null
                    : 'Minimum 6 caractères',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: appeler le usecase d'inscription
                  }
                },
                child: const Text('S'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}