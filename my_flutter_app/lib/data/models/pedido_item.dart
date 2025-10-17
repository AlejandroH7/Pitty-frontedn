import 'postre.dart';

class PedidoItem {
  PedidoItem({
    required this.postre,
    this.cantidad = 1,
  });

  final Postre postre;
  int cantidad;

  double get subtotal => postre.precio * cantidad;
}
