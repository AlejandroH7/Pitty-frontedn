import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class HttpClient {
  HttpClient({
    required this.baseUrl,
    http.Client? httpClient,
    Duration? timeout,
  })  : _client = httpClient ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 15);

  final String baseUrl;
  final http.Client _client;
  final Duration _timeout;
  String? Function()? _tokenProvider;

  void registerTokenProvider(String? Function() provider) {
    _tokenProvider = provider;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _client
        .get(
          _buildUri(path, queryParameters),
          headers: _buildHeaders(headers),
        )
        .timeout(_timeout);
    return _handleResponse<T>(response);
  }

  Future<T?> post<T>(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client
        .post(
          _buildUri(path),
          headers: _buildHeaders(headers),
          body: _encodeBody(body),
        )
        .timeout(_timeout);
    return _handleResponse<T>(response);
  }

  Future<T?> put<T>(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client
        .put(
          _buildUri(path),
          headers: _buildHeaders(headers),
          body: _encodeBody(body),
        )
        .timeout(_timeout);
    return _handleResponse<T>(response);
  }

  Future<T?> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final response = await _client
        .delete(
          _buildUri(path, queryParameters),
          headers: _buildHeaders(headers),
        )
        .timeout(_timeout);
    return _handleResponse<T>(response);
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final normalizedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    );
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final merged = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?headers,
    };
    final token = _tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      merged['Authorization'] = 'Bearer $token';
    }
    return merged;
  }

  String? _encodeBody(Object? body) {
    if (body == null) {
      return null;
    }
    if (body is String) {
      return body;
    }
    return jsonEncode(body);
  }

  T? _handleResponse<T>(http.Response response) {
    final status = response.statusCode;
    final bodyText = response.body;
    if (status >= 200 && status < 300) {
      if (bodyText.isEmpty) {
        return null;
      }
      return _decodeBody(bodyText) as T?;
    }
    final decodedBody = bodyText.isEmpty ? null : _decodeBody(bodyText);
    final message = _extractErrorMessage(decodedBody) ??
        (status >= 500
            ? 'Error interno del servidor ($status). Intenta nuevamente más tarde.'
            : 'Error en la solicitud ($status). Verifica los datos enviados.');
    throw ApiException(status, message, decodedBody);
  }

  dynamic _decodeBody(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String? _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body['mensaje'] != null) {
        return body['mensaje'].toString();
      }
      if (body['message'] != null) {
        return body['message'].toString();
      }
      if (body['error'] != null) {
        return body['error'].toString();
      }
      if (body['detail'] != null) {
        return body['detail'].toString();
      }
    }
    return null;
  }

  void close() {
    _client.close();
  }
}