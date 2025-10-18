import '../models/pedido.dart';
import '../models/pedido_item.dart';

abstract class PedidosRepository {
  Future<Pedido> confirmarPedido({
    required List<PedidoItem> items,
    DateTime? fechaEntrega,
    int? clienteId,
    String? notas,
  });

  Future<List<Pedido>> obtenerHistorial({
    String? query,
    DateTime? desde,
    DateTime? hasta,
  });
}