// AuthLayout (optionnel pour réutilisation UI)
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AuthLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logos/leloprof.png', height: 100),
              const SizedBox(height: 20),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
