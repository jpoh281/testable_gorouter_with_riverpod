
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/screen/screens.dart';

import '../../test_helper/provide_app_router.dart';
import '../../test_helper/provide_container.dart';
import '../robot/home_screen_robot.dart';

void main() {
  testWidgets('[로그인 확인 상태]일 때 [Home Screen]으로 오면 [Splash Screen] 리다이렉트 된다.',
      (tester) async {
    // GIVEN - 로그인 되어있지 않은 상태
    final robot = HomeScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticating());
    final router = provideDefaultAppRouter(container, '/');

    // WHEN - [HomeScreen]으로 오면
    await robot.pumpHomeScreenAndSettle(container, router);
    await tester.pump(const Duration(milliseconds: 500));

    // THEN - [Splash Screen]으로 간다.
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('[비 로그인 상태]일 때 [로그인 버튼]을 누르면 [Auth Screen]으로 간다.', (tester) async {
    // GIVEN - 로그인 되어있지 않은 상태
    final robot = HomeScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/');
    await robot.pumpHomeScreenAndSettle(container, router);
    expect(find.byType(HomeScreen), findsOneWidget);

    // WHEN - 로그인 버튼을 누른다.
    await robot.tabGoToAuthScreenButton();

    // THEN - [Auth Screen]으로 간다.
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('[비 로그인 상태]일 때 [마이 페이지 버튼]을 누르면 [Auth Screen]으로 간다.',
      (tester) async {
    // GIVEN - 로그인 되어있지 않은 상태
    final robot = HomeScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/');
    await robot.pumpHomeScreenAndSettle(container, router);
    expect(find.byType(HomeScreen), findsOneWidget);

    // WHEN - 로그인 버튼을 누른다.
    await robot.tabGoToMyScreenButton();

    // THEN - [Auth Screen]으로 간다.
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('[로그인 상태]일 때 [로그인 버튼]을 누르면 [Home Screen]에 그대로 있는다', (tester) async {
    // GIVEN - 로그인 되어 있는 상태
    final robot = HomeScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticated(""));
    final router = provideDefaultAppRouter(container, '/');
    await robot.pumpHomeScreenAndSettle(container, router);
    expect(find.byType(HomeScreen), findsOneWidget);

    // WHEN - 로그인 버튼을 누른다.
    await robot.tabGoToAuthScreenButton();

    // THEN - Home Screen에 그대로 있는다
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('[로그인 상태]일 때 [마이 페이지 버튼]을 누르면 [Home Screen]에 그대로 있는다', (tester) async {
    // GIVEN - 로그인 되어 있는 상태
    final robot = HomeScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticated(""));
    final router = provideDefaultAppRouter(container, '/');
    await robot.pumpHomeScreenAndSettle(container, router);
    expect(find.byType(HomeScreen), findsOneWidget);

    // WHEN - 마이페이지 버튼을 누른다.
    await robot.tabGoToMyScreenButton();

    // THEN - Home Screen에 그대로 있는다
    await tester.pumpAndSettle();
    expect(find.byType(MyScreen), findsOneWidget);
  });
}
