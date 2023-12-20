import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_example/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubsciption;

  @override
  void initState() {
    super.initState();
    _authSubsciption = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubsciption.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _emailController,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase.auth.signInWithOtp(
                  email: _emailController.text.trim(),
                  emailRedirectTo: kIsWeb
                      ? null
                      : 'io.supabase.flutterquickstart://login-callback/',
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check your email for a login link!'),
                    ),
                  );
                }
              } on AuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              } finally {}
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
