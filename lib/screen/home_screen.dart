import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth_notifier.dart';
import 'package:testable_gorouter_with_riverpod/router/routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "User: ${ref.watch(authNotifierProvider)}",
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              const AuthRoute().go(context);
            },
            child: const Text("Go To Auth Screen"),
          ),
          TextButton(
            onPressed: () {
              const MyRoute().go(context);
            },
            child: const Text("Go To My Screen"),
          ),
        ],
      ),
    );
  }
}
