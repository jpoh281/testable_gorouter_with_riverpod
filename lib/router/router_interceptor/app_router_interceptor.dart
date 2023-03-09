import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class AppRouterInterceptor {
  FutureOr<String?> canGo(
      BuildContext context, GoRouterState routerState);
}
