import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_state.dart';

part 'auth_notifier.g.dart';

@Riverpod(dependencies: [])
class AuthNotifier extends _$AuthNotifier {
  final AuthState initialState;

  AuthNotifier({this.initialState = const Authenticating()});

  @override
  AuthState build() {
    return initialState;
  }

  void login() {
    state = const Authenticated("test-token");
  }

  void logout() {
    state = const Unauthenticated();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = const Unauthenticated();
  }
}
