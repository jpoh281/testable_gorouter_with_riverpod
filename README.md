# testable_gorouter_with_riverpod
An example to make testing GoRouter easier with Riverpod

This example is inspired by [lucavenir / go_router_riverpod](https://github.com/lucavenir/go_router_riverpod)

## The focus was on making the three tests easier to do.
- Initial route
- RefreshListenable
- Redirect

Considered how to easily test initial route, redirect, and refreshListenable.

Create GoRouter's wrapper class and inject three things in it.

In addition, for redirect,
An interface called Interceptor was create so that it could also be tested as a unit test.

## AppRouter

```dart
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
```
## AppRouterInterceptor

```dart
abstract class AppRouterInterceptor {
  FutureOr<String?> canGo(
      BuildContext context, GoRouterState routerState);
}
```

```dart
@Riverpod(dependencies: [AuthNotifier])
AuthScreenInterceptor authScreenInterceptor(AuthScreenInterceptorRef ref) {
  return AuthScreenInterceptor(ref);
}

class AuthScreenInterceptor implements AppRouterInterceptor {
  final Ref ref;

  AuthScreenInterceptor(this.ref);

  @override
  String? canGo(BuildContext context, GoRouterState routerState) {
    final authState = ref.read(authNotifierProvider);
    final isAuth = routerState.location == const AuthRoute().location;

    if (isAuth && authState is Authenticated) {
      return HomeRoute.path;
    }

    return null;
  }
}
```

## RouterNotifier

```dart
@Riverpod(dependencies: [AuthNotifier])
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? routerListener;

  AuthState authState = const Authenticating();

  @override
  Future<void> build() async {
    authState = await ref.watch(authNotifierProvider);

    ref.listenSelf((_, __) {
      if (state.isLoading) return;
      routerListener?.call();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}
```


## Unit Test
```dart
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
```

## Widget Test
```dart
class HomeScreenRobot {
  final WidgetTester tester;

  HomeScreenRobot(this.tester);

  Future<void> pumpHomeScreenAndSettle(
      ProviderContainer container, AppRouter router) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router.config,
        ),
      ),
    );

    await tester.pump();
  }

  Future<void> tabGoToAuthScreenButton() async {
    await tester.tap(find.text('Go To Auth Screen'));
  }

  Future<void> tabGoToMyScreenButton() async {
    await tester.tap(find.text('Go To My Screen'));
  }
}
```
```dart
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
```
