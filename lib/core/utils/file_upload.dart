import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'env.dart';

/// Enum for file upload types
enum FileUploadType {
  profilePicture,
  // Add more types as needed
}

/// Extension to convert FileUploadType to API string format
extension FileUploadTypeExtension on FileUploadType {
  String get value {
    switch (this) {
      case FileUploadType.profilePicture:
        return 'PROFILE_PICTURE';
    }
  }
}

/// Response type for image upload
class ImageUploadResponse {
  final String? url;
  final Map<String, dynamic>? response;

  ImageUploadResponse({this.url, this.response});

  /// Create ImageUploadResponse from JSON
  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      url: json['url'] as String?,
      response: json['response'] as Map<String, dynamic>?,
    );
  }

  /// Convert ImageUploadResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      if (url != null) 'url': url,
      if (response != null) 'response': response,
    };
  }
}

/// Upload a file using multipart/form-data
///
/// [file] - The XFile to upload (optional)
/// [token] - Authorization bearer token
/// [type] - The type of image being uploaded (required) - can use FileUploadType enum
/// [sync] - Optional sync flag
/// [data] - Optional additional data as a Map (will be JSON stringified)
///
/// Returns ImageUploadResponse if successful
/// Throws an Exception if the upload fails
Future<ImageUploadResponse> uploadFile({
  XFile? file,
  required String token,
  required FileUploadType type,
  bool? sync,
  Map<String, dynamic>? data,
}) async {
  try {
    // Get the base URL from environment
    final baseUrl = getEnvVar(EnvKey.backendBaseUrl);
    final uri = Uri.parse('$baseUrl/image');

    // Create multipart request with PUT method
    final request = http.MultipartRequest('PUT', uri);

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add type field (required) - convert enum to string
    request.fields['type'] = type.value;

    // Add file if provided
    if (file != null) {
      final fileBytes = await file.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: file.name,
      );
      request.files.add(multipartFile);
    }

    // Add sync field if provided
    if (sync != null) {
      request.fields['sync'] = sync.toString();
    }

    // Add data field if provided (JSON stringified)
    if (data != null) {
      request.fields['data'] = jsonEncode(data);
    }

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Parse JSON response
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    // Check if successful
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ImageUploadResponse.fromJson(responseData);
    } else {
      throw Exception(
        'Failed to upload file: ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
    throw Exception('Error uploading file: $e');
  }
}
