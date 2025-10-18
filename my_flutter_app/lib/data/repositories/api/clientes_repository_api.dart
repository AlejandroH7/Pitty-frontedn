import '../../models/cliente.dart';
import '../clientes_repository.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/http/http_client.dart';

class ClientesRepositoryApi implements ClientesRepository {
  ClientesRepositoryApi(this._client);

  final HttpClient _client;
  static const String _resource = '/clientes';

  @override
  Future<Cliente> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? notas,
  }) async {
    final payload = <String, dynamic>{
      'nombre': nombre.trim(),
      if (telefono != null && telefono.trim().isNotEmpty)
        'telefono': telefono.trim(),
      if (notas != null && notas.trim().isNotEmpty) 'notas': notas.trim(),
    };
    final result = await _client.put<Map<String, dynamic>>(
      '$_resource/$id',
      body: payload,
    );
    if (result == null) {
      throw ApiException(500, 'No se pudo actualizar el cliente');
    }
    return Cliente.fromJson(result);
  }

  @override
  Future<Cliente> crear({
    required String nombre,
    String? telefono,
    String? notas,
  }) async {
    final payload = <String, dynamic>{
      'nombre': nombre.trim(),
      if (telefono != null && telefono.trim().isNotEmpty)
        'telefono': telefono.trim(),
      if (notas != null && notas.trim().isNotEmpty) 'notas': notas.trim(),
    };
    final result = await _client.post<Map<String, dynamic>>(
      _resource,
      body: payload,
    );
    if (result == null) {
      throw ApiException(500, 'No se pudo crear el cliente');
    }
    return Cliente.fromJson(result);
  }

  @override
  Future<void> eliminar(int id) async {
    await _client.delete<void>('$_resource/$id');
  }

  @override
  Future<Cliente?> obtenerPorId(int id) async {
    try {
      final result = await _client.get<Map<String, dynamic>>('$_resource/$id');
      if (result == null) {
        return null;
      }
      return Cliente.fromJson(result);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<Cliente>> obtenerTodos() async {
    final result = await _client.get<List<dynamic>>(_resource);
    if (result == null) {
      return const [];
    }
    return result
        .whereType<Map<String, dynamic>>()
        .map(Cliente.fromJson)
        .toList();
  }
}