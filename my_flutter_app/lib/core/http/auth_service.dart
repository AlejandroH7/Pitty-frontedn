import '../config/app_config.dart';
import 'api_exception.dart';
import 'http_client.dart';

class AuthService {
  AuthService(this._client) {
    _client.registerTokenProvider(() => _token);
  }

  final HttpClient _client;
  String? _token;

  String? get token => _token;

  Future<void> loginIfNeeded() async {
    if (AppConfig.apiUsername.isEmpty || AppConfig.apiPassword.isEmpty) {
      return;
    }
    final response = await _client.post<Map<String, dynamic>>(
      AppConfig.authPath,
      body: {
        'username': AppConfig.apiUsername,
        'password': AppConfig.apiPassword,
      },
    );
    if (response == null) {
      throw ApiException(500, 'No se recibió respuesta del servicio de autenticación');
    }
    final token = _extractToken(response);
    if (token == null || token.isEmpty) {
      throw ApiException(500, 'El servicio de autenticación no devolvió un token válido', response);
    }
    _token = token;
  }

  String? _extractToken(Map<String, dynamic> data) {
    if (data['token'] is String) {
      return data['token'] as String;
    }
    if (data['access_token'] is String) {
      return data['access_token'] as String;
    }
    if (data['accessToken'] is String) {
      return data['accessToken'] as String;
    }
    if (data['jwt'] is String) {
      return data['jwt'] as String;
    }
    return null;
  }
}