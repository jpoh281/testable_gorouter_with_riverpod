import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth_notifier.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Screen'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).login();
          },
          child: const Text("LogIn"),
        ),
      ),
    );
  }
}
