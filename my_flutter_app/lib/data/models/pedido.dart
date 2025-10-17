import 'cliente.dart';
import 'pedido_item.dart';

class Pedido {
  Pedido({
    required this.id,
    required this.items,
    this.cliente,
    this.notas,
    required this.fechaCreacion,
  });

  final int id;
  final List<PedidoItem> items;
  final Cliente? cliente;
  final String? notas;
  final DateTime fechaCreacion;

  double get total => items.fold(
      0, (previousValue, element) => previousValue + element.subtotal);
}
