import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import '../bloc/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth(context);
  }

  void _checkAuth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final authState = context.read<AuthBloc>().state;

    if (authState is Authenticated) {
      context.go('/home');
    } else {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logos/leloprof.png', width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.red),
          ],
        ),
      ),
    );
  }
}
