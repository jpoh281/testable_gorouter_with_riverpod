
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/screen/screens.dart';

import '../../test_helper/provide_app_router.dart';
import '../../test_helper/provide_container.dart';
import '../../test_helper/listen_router_notifier.dart';
import '../robot/auth_screen_robot.dart';

main() {
  testWidgets('[로그인 상태]일 때 [Auth Screen]으로 오면 [Home Screen]으로 리다이렉트 된다.',
      (tester) async {
    // GIVEN - 로그인 상태
    final robot = AuthScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticated(""));
    final router = provideDefaultAppRouter(container, '/auth');
    listenRouterNotifier(container);

    // WHEN - [AuthScreen]으로 오면
    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();

    // THEN - [HomeScreen]으로 간다.
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets("[비 로그인 상태]일 때만 [Auth Screen]으로 올 수 있다.", (tester) async {
    // GIVEN - 비 로그인 된 상태
    final robot = AuthScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/auth');
    listenRouterNotifier(container);

    // WHEN - [AuthScreen]으로 오면
    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();

    // THEN - [AuthScreen]으로 간다.
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets("로그인에 성공하면 [Home Screen]으로 리다이렉트 된다.", (tester) async {
    // GIVEN - 로그인 되어있지 않은 상태
    final robot = AuthScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/auth');
    listenRouterNotifier(container);

    // WHEN - [AuthScreen]으로 오면
    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();

    // THEN - [AuthScreen]으로 간다.
    expect(find.byType(AuthScreen), findsOneWidget);

    // WHEN - 로그인 버튼을 누르면
    await robot.tabLogInButton();
    await tester.pumpAndSettle();

    // THEN - [HomeScreen]으로 간다.
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
