
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/auth/auth.dart';
import 'package:testable_gorouter_with_riverpod/screen/screens.dart';

import '../../test_helper/provide_app_router.dart';
import '../../test_helper/provide_container.dart';
import '../../test_helper/listen_router_notifier.dart';
import '../robot/my_screen_robot.dart';

void main() {
  testWidgets('[비 로그인 상태]일 때 [My Screen]으로 오면 [Auth Screen]으로 간다.',
      (tester) async {
    // GIVEN - 비 로그인 상태
    final robot = MyScreenRobot(tester);
    final container = provideDefaultContainer(const Unauthenticated());
    final router = provideDefaultAppRouter(container, '/my');

    // WHEN - [My Screen]으로 오면
    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();

    // THEN - [Auth Screen]으로 간다.
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('[로그인 상태]일 때만 [My Screen]으로 갈 수 있다.', (tester) async {
    // GIVEN - 로그인 상태
    final robot = MyScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticated(''));
    final router = provideDefaultAppRouter(container, '/my');

    // WHEN - [My Screen]으로 오면
    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();

    // THEN - [Home Screen]으로 간다.
    expect(find.byType(MyScreen), findsOneWidget);
  });

  testWidgets('로그아웃 버튼을 누르면 [AuthScreen]으로 간다', (tester) async {
    // GIVEN - 로그인 되어 있는 상태
    final robot = MyScreenRobot(tester);
    final container = provideDefaultContainer(const Authenticated(''));
    final router = provideDefaultAppRouter(container, '/my');
    listenRouterNotifier(container);

    await robot.pumpMyScreenAndSettle(container, router);
    await tester.pumpAndSettle();
    expect(find.byType(MyScreen), findsOneWidget);

    // WHEN - [My Screen]으로 오면
    await robot.tabLogOutButton();
    await tester.pumpAndSettle();
    // THEN - [Auth Screen]으로 간다.
    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
