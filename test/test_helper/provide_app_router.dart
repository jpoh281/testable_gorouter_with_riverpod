
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable_gorouter_with_riverpod/router/router.dart';
import 'package:testable_gorouter_with_riverpod/router/router_interceptor/interceptors.dart';
import 'package:testable_gorouter_with_riverpod/router/router_notifier.dart';

AppRouter provideDefaultAppRouter(ProviderContainer container, String initialRoute) {
  return AppRouter(
    container.read(routerNotifierProvider.notifier),
    initialRoute,
    [
      container.read(authScreenInterceptorProvider),
      container.read(needAuthScreenInterceptorProvider),
      container.read(splashScreenInterceptorProvider),
    ],
  );
}
