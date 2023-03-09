abstract class AuthState {
  const AuthState();
}

class Authenticated extends AuthState {
  final String token;

  const Authenticated(this.token);

  @override
  String toString() {
    return '로그인 상태';
  }
}

class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  String toString() {
    return '비 로그인 상태';
  }
}

class Authenticating extends AuthState {
  const Authenticating();
}
