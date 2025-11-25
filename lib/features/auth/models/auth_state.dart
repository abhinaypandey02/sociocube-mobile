// Auth state
class AuthState {
  final int? userId;
  final String? accessToken;

  AuthState({this.userId, this.accessToken});

  bool get isAuthenticated => accessToken != null;

  AuthState copyWith({int? userId, String? accessToken}) {
    return AuthState(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  AuthState clear() {
    return AuthState();
  }
}
