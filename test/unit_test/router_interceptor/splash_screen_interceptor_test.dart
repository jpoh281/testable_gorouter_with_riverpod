
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/router/router_interceptor/interceptors.dart';

import '../../mock/mock_build_context.mocks.dart';
import '../../mock/mock_go_router_state.mocks.dart';
import '../../test_helper/provide_container.dart';

main() {
  MockBuildContext buildContext = MockBuildContext();
  MockGoRouterState goRouterState = MockGoRouterState();

  test('[로그인 확인 상태] + /splash => null', () {
    when(goRouterState.location).thenReturn('/splash');
    ProviderContainer container =
    provideDefaultContainer(const Authenticating());
    SplashScreenInterceptor interceptor =
    container.read(splashScreenInterceptorProvider);

    interceptor.canGo(buildContext, goRouterState);

    expect(interceptor.canGo(buildContext, goRouterState), null);
  });

  for (var element in const [Authenticated(""), Unauthenticated()]) {
    test('[$element] + /splash => /', () {
      when(goRouterState.location).thenReturn('/splash');
      ProviderContainer container =
      provideDefaultContainer(element);
      SplashScreenInterceptor interceptor =
      container.read(splashScreenInterceptorProvider);

      interceptor.canGo(buildContext, goRouterState);

      expect(interceptor.canGo(buildContext, goRouterState), '/');
    });
  }
}
