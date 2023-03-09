import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/router/routes.dart';

import 'app_router_interceptor.dart';

part 'need_auth_screen_interceptor.g.dart';

@Riverpod(dependencies: [AuthNotifier])
NeedAuthScreenInterceptor needAuthScreenInterceptor(
    NeedAuthScreenInterceptorRef ref) {
  return NeedAuthScreenInterceptor(ref);
}

class NeedAuthScreenInterceptor implements AppRouterInterceptor {
  final Ref ref;

  NeedAuthScreenInterceptor(this.ref);

  @override
  String? canGo(BuildContext context, GoRouterState routerState) {
    final authState = ref.read(authNotifierProvider);
    final isMy = routerState.location == const MyRoute().location;

    if (isMy && authState is! Authenticated) {
      return const AuthRoute().location;
    }

    return null;
  }
}
