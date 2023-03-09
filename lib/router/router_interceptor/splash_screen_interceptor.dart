import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/router/routes.dart';

import 'app_router_interceptor.dart';

part 'splash_screen_interceptor.g.dart';

@Riverpod(dependencies: [AuthNotifier])
SplashScreenInterceptor splashScreenInterceptor(
    SplashScreenInterceptorRef ref) {
  return SplashScreenInterceptor(ref);
}

class SplashScreenInterceptor implements AppRouterInterceptor {
  final Ref ref;

  SplashScreenInterceptor(this.ref);

  @override
  String? canGo(BuildContext context, GoRouterState routerState) {
    final authState = ref.read(authNotifierProvider);
    final isSplash = routerState.location == SplashRoute.path;

    if (!isSplash && authState is Authenticating) return SplashRoute.path;
    if (isSplash && authState is! Authenticating) return HomeRoute.path;
    return null;
  }
}
