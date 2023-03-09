import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth_notifier.dart';

import 'router_interceptor/app_router_interceptor.dart';
import 'router_interceptor/interceptors.dart';
import 'router_notifier.dart';
import 'routes.dart';

part 'router.g.dart';

final _key = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

@Riverpod(dependencies: [
  RouterNotifier,
  splashScreenInterceptor,
  authScreenInterceptor,
  needAuthScreenInterceptor
])
AppRouter router(RouterRef ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return AppRouter(notifier, '/', [
    ref.watch(splashScreenInterceptorProvider),
    ref.watch(authScreenInterceptorProvider),
    ref.watch(needAuthScreenInterceptorProvider)
  ]);
}

class AppRouter {
  final Listenable _notifier;
  final String _initialLocation;
  final List<AppRouterInterceptor> _interceptors;

  AppRouter(this._notifier, this._initialLocation, this._interceptors);

  late final GoRouter config = GoRouter(
      navigatorKey: _key,
      initialLocation: _initialLocation,
      refreshListenable: _notifier,
      redirect: (context, state) async {
        // 배열의 canGo를 동작시키다가 null이 아닌 Interceptor가 나오면 해당 Interceptor의 canGo를 반환한다.
        // 만약 모든 Interceptor의 canGo가 null이면 null을 반환한다.
        for (AppRouterInterceptor interceptor in _interceptors) {
          final String? result = await interceptor.canGo(context, state);
          if (result != null) return result;
        }
        return null;
      },
      debugLogDiagnostics: true,
      routes: $appRoutes);
}
