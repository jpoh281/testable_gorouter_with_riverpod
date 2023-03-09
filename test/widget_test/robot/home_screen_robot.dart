import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testable_gorouter_with_riverpod/router/router.dart';

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
