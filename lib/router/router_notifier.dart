import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';

part 'router_notifier.g.dart';

@Riverpod(dependencies: [AuthNotifier])
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? routerListener;

  AuthState authState = const Authenticating();

  @override
  Future<void> build() async {
    authState = await ref.watch(authNotifierProvider);

    ref.listenSelf((_, __) {
      if (state.isLoading) return;
      routerListener?.call();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}
