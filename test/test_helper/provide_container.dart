import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/router/router_interceptor/interceptors.dart';
import 'package:testable_gorouter_with_riverpod/router/router_notifier.dart';

ProviderContainer provideDefaultContainer(AuthState authState,
    {List<Override> additionalOverrides = const []}) {
  return ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => AuthNotifier(
          initialState: authState,
        ),
      ),
      routerNotifierProvider.overrideWith(
        () => RouterNotifier(),
      ),
      authScreenInterceptorProvider.overrideWith(
        (ref) => AuthScreenInterceptor(ref),
      ),
      needAuthScreenInterceptorProvider.overrideWith(
        (ref) => NeedAuthScreenInterceptor(ref),
      ),
      splashScreenInterceptorProvider.overrideWith(
        (ref) => SplashScreenInterceptor(ref),
      ),
      ...additionalOverrides
    ],
  );
}
