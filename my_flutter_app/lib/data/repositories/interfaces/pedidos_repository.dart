import 'package:pitty_app/data/models/models.dart';

class PedidoItemInput {
  const PedidoItemInput({
    required this.postreId,
    required this.cantidad,
    required this.precioUnitario,
    this.personalizaciones,
  });

  final int postreId;
  final int cantidad;
  final double precioUnitario;
  final Map<String, dynamic>? personalizaciones;
}

abstract class PedidosRepository {
  Future<List<Pedido>> listar({String? query, DateTime? desde, DateTime? hasta});
  Future<Pedido> obtener(int id);
  Future<Pedido> crear({
    required int clienteId,
    required DateTime fechaEntrega,
    String? notas,
    required List<PedidoItemInput> items,
    bool simulateError = false,
  });
  Future<Pedido> actualizarEstado({
    required int id,
    required PedidoEstado estado,
    bool simulateError = false,
  });
  Future<void> eliminar(int id);
}
