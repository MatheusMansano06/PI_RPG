import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiClient {
  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.runtimeBaseUrl}$normalizedPath');
  }

  Future<dynamic> get(String path) async {
    final response = await _httpClient.get(_buildUri(path));
    return _decodeResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  dynamic _decodeResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.trim();

    if (statusCode < 200 || statusCode >= 300) {
      final message = _errorMessageFromBody(body);
      throw ApiException(
        statusCode: statusCode,
        message: message ?? 'Erro HTTP $statusCode',
      );
    }

    if (body.isEmpty) {
      return null;
    }

    return jsonDecode(body);
  }

  String? _errorMessageFromBody(String body) {
    if (body.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];
        if (error is String && error.trim().isNotEmpty) {
          return error;
        }
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      return body;
    }

    return body;
  }
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
