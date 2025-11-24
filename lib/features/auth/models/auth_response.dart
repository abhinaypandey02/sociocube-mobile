import 'package:jwt_decoder/jwt_decoder.dart';
import 'user.dart';

class AuthResponse {
  final String accessToken;
  final String? refreshToken;

  AuthResponse({required this.accessToken, this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  /// Convert to User entity
  User toUser() {
    final decoded = JwtDecoder.decode(accessToken);
    return User(
      id: decoded['id'] ?? '',
    );
  }
}
