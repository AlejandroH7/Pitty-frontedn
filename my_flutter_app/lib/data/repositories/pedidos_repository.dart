import '../models/pedido.dart';
import '../models/pedido_item.dart';

abstract class PedidosRepository {
  Future<Pedido> confirmarPedido({
    required List<PedidoItem> items,
    String? notas,
  });

  Future<List<Pedido>> obtenerHistorial();
}
