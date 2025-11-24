import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import '../models/auth_response.dart';
import '../../../core/utils/env.dart';

class AuthApi {
  final http.Client client;
  static const String _endpoint = '/email';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  AuthApi({http.Client? client}) : client = client ?? http.Client();

  Uri _getUri() {
    final baseUrl = getEnvVar(EnvKey.backendBaseUrl);
    return Uri.parse('$baseUrl$_endpoint');
  }

  Future<String?> _getCaptchaToken() async {
    final turnstile = CloudflareTurnstile.invisible(
      siteKey: getEnvVar(EnvKey.turnstileSiteKey),
    );

    try {
      return turnstile.getToken();
    } catch (e) {
      return null;
    } finally {
      turnstile.dispose();
    }
  }

  Future<String> _buildRequestBody({
    required String email,
    required String password,
  }) async {
    final captchaToken = await _getCaptchaToken();
    return json.encode({
      'email': email,
      'password': password,
      'captchaToken': captchaToken,
    });
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.put(
        _getUri(),
        headers: _headers,
        body: await _buildRequestBody(email: email, password: password),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Login failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<AuthResponse> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        _getUri(),
        headers: _headers,
        body: await _buildRequestBody(email: email, password: password),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Signup failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final headers = Map<String, String>.from(_headers);
      headers['Cookie'] = 'refresh=$refreshToken';

      final response = await client.get(_getUri(), headers: headers);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        return authResponse.accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
