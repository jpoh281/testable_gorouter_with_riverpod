
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

  test('[로그인 상태] + /auth => /', () {
    when(goRouterState.location).thenReturn('/auth');
    ProviderContainer container =
        provideDefaultContainer(const Authenticated(''));
    AuthScreenInterceptor interceptor =
        container.read(authScreenInterceptorProvider);

    interceptor.canGo(buildContext, goRouterState);

    expect(interceptor.canGo(buildContext, goRouterState), "/");
  });

  test('[비 로그인 상태] + /auth => null', () {
    when(goRouterState.location).thenReturn('/auth');
    ProviderContainer container =
    provideDefaultContainer(const Unauthenticated());
    AuthScreenInterceptor interceptor =
    container.read(authScreenInterceptorProvider);

    interceptor.canGo(buildContext, goRouterState);

    expect(interceptor.canGo(buildContext, goRouterState), null);
  });
}
