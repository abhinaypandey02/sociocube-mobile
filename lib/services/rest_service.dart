import 'dart:convert';
import 'package:http/http.dart' as http;

class RestService {
  static const String baseUrl = 'https://your-rest-api.com/api';

  // Example GET request
  static Future<http.Response> getExample() async {
    final response = await http.get(Uri.parse('$baseUrl/example'));
    return response;
  }

  // Example POST request
  static Future<http.Response> postExample(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/example'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
} 