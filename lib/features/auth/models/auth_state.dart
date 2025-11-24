import './user.dart';

// Auth state
class AuthState {
  final User? user;
  final String? accessToken;

  AuthState({this.user, this.accessToken});

  bool get isAuthenticated => accessToken != null;

  AuthState copyWith({User? user, String? accessToken}) {
    return AuthState(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  AuthState clear() {
    return AuthState();
  }
}
