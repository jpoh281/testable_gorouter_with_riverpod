import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/router/routes.dart';

import 'app_router_interceptor.dart';

part 'auth_screen_interceptor.g.dart';

@Riverpod(dependencies: [AuthNotifier])
AuthScreenInterceptor authScreenInterceptor(AuthScreenInterceptorRef ref) {
  return AuthScreenInterceptor(ref);
}

class AuthScreenInterceptor implements AppRouterInterceptor {
  final Ref ref;

  AuthScreenInterceptor(this.ref);

  @override
  String? canGo(BuildContext context, GoRouterState routerState) {
    final authState = ref.read(authNotifierProvider);
    final isAuth = routerState.location == const AuthRoute().location;

    if (isAuth && authState is Authenticated) {
      return HomeRoute.path;
    }

    return null;
  }
}
