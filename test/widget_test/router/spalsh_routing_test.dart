
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/screen/screens.dart';

import '../../test_helper/listen_router_notifier.dart';
import '../../test_helper/provide_app_router.dart';
import '../../test_helper/provide_container.dart';
import '../robot/splash_screen_robot.dart';

void main() {
  testWidgets('[로그인 확인 상태]일 때 [Splash Screen]에 간다.', (tester) async {
    // GIVEN - [로그인 확인 상태]
    final robot = SplashScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticating());
    final router = provideDefaultAppRouter(container, '/splash');

    // WHEN - [HomeScreen]으로 오면
    await robot.pumpSplashScreenAndSettle(container, router);
    await tester.pump(const Duration(seconds: 1));
    // THEN - [Splash Screen]으로 간다.
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('로그인 값이 변경되면 [Splash Screen]에 간다.', (tester) async {
    // GIVEN - [로그인 확인 상태]
    final robot = SplashScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticating());
    final router = provideDefaultAppRouter(container, '/splash');
    listenRouterNotifier(container);

    // WHEN - [HomeScreen]으로 오면
    await robot.pumpSplashScreenAndSettle(container, router);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // THEN - [Home Screen]으로 간다.
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('[로그인 확인 상태]가 아닐 때 [Splash Screen]로 가면 [Home Screen]으로 간다.',
      (tester) async {
    // GIVEN - 로그인 되어있지 않은 상태
    final robot = SplashScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/splash');
    await tester.runAsync(() async {
      await robot.pumpSplashScreenAndSettle(container, router);
    });
    await tester.pump(Duration.zero);

    // THEN - [Home Screen]으로 간다
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
