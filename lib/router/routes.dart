import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testable_gorouter_with_riverpod/screen/screens.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: SplashRoute.path)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  static const path = '/splash';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<HomeRoute>(path: HomeRoute.path, routes: [
  TypedGoRoute<MyRoute>(path: MyRoute.path),
  TypedGoRoute<AuthRoute>(path: AuthRoute.path),
])
class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class MyRoute extends GoRouteData {
  const MyRoute();

  static const path = 'my';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyScreen();
  }
}

class AuthRoute extends GoRouteData {
  const AuthRoute();

  static const path = 'auth';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthScreen();
  }
}
