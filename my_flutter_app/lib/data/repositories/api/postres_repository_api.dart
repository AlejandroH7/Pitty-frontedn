import '../../models/postre.dart';
import '../postres_repository.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/http/http_client.dart';

class PostresRepositoryApi implements PostresRepository {
  PostresRepositoryApi(this._client);

  final HttpClient _client;
  static const String _resource = '/postres';

  @override
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
  }) async {
    final payload = <String, dynamic>{
      'nombre': nombre.trim(),
      'precio': precio,
      'porciones': porciones,
      'activo': activo,
    };
    final result = await _client.put<Map<String, dynamic>>(
      '$_resource/$id',
      body: payload,
    );
    if (result == null) {
      throw ApiException(500, 'No se pudo actualizar el postre');
    }
    return Postre.fromJson(result);
  }

  @override
  Future<Postre> crear({
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
  }) async {
    final payload = <String, dynamic>{
      'nombre': nombre.trim(),
      'precio': precio,
      'porciones': porciones,
      'activo': activo,
    };
    final result = await _client.post<Map<String, dynamic>>(
      _resource,
      body: payload,
    );
    if (result == null) {
      throw ApiException(500, 'No se pudo crear el postre');
    }
    return Postre.fromJson(result);
  }

  @override
  Future<void> eliminar(int id) async {
    await _client.delete<void>('$_resource/$id');
  }

  @override
  Future<Postre?> obtenerPorId(int id) async {
    try {
      final result = await _client.get<Map<String, dynamic>>('$_resource/$id');
      if (result == null) {
        return null;
      }
      return Postre.fromJson(result);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<Postre>> obtenerTodos() async {
    final result = await _client.get<List<dynamic>>(_resource);
    if (result == null) {
      return const [];
    }
    return result
        .whereType<Map<String, dynamic>>()
        .map(Postre.fromJson)
        .toList();
  }
}