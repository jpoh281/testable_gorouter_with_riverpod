import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/router/router.dart';

class MyScreenRobot {
  final WidgetTester tester;

  MyScreenRobot(this.tester);

  Future<void> pumpMyScreenAndSettle(
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

  Future<void> tabLogOutButton() async {
    await tester.tap(find.text('LogOut'));
    await tester.pump();
  }
}
