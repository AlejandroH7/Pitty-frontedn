import '../../models/pedido.dart';
import '../../models/pedido_item.dart';
import '../pedidos_repository.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/http/http_client.dart';

class PedidosRepositoryApi implements PedidosRepository {
  PedidosRepositoryApi(this._client);

  final HttpClient _client;
  static const String _resource = '/pedidos';

  @override
  Future<Pedido> confirmarPedido({
    required List<PedidoItem> items,
    DateTime? fechaEntrega,
    int? clienteId,
    String? notas,
  }) async {
    final entrega = fechaEntrega ?? DateTime.now();
    final payload = <String, dynamic>{
      'fechaEntrega': entrega.toUtc().toIso8601String(),
      'items': items.map((item) => item.toRequestJson()).toList(),
      if (clienteId != null) 'clienteId': clienteId,
    };
    final trimmedNotes = notas?.trim();
    if (trimmedNotes != null && trimmedNotes.isNotEmpty) {
      payload['notas'] = trimmedNotes;
    }
    final result = await _client.post<Map<String, dynamic>>(
      _resource,
      body: payload,
    );
    if (result == null) {
      throw ApiException(500, 'No se pudo crear el pedido');
    }
    return Pedido.fromJson(result);
  }

  @override
  Future<List<Pedido>> obtenerHistorial({
    String? query,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final params = <String, dynamic>{};
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      params['q'] = trimmedQuery;
    }
    if (desde != null) {
      params['desde'] = _formatDate(desde);
    }
    if (hasta != null) {
      params['hasta'] = _formatDate(hasta);
    }
    final result = await _client.get<List<dynamic>>(
      _resource,
      queryParameters: params.isEmpty ? null : params,
    );
    if (result == null) {
      return const [];
    }
    return result
        .whereType<Map<String, dynamic>>()
        .map(Pedido.fromJson)
        .toList();
  }

  String _formatDate(DateTime value) {
    return value.toUtc().toIso8601String().split('T').first;
  }
}