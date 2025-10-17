import 'dart:async';

import '../models/cliente.dart';
import '../models/pedido.dart';
import '../models/pedido_item.dart';
import 'pedidos_repository.dart';

class PedidosRepositoryMem implements PedidosRepository {
  PedidosRepositoryMem();

  final List<Pedido> _historial = [];
  int _sequence = 1;

  @override
  Future<Pedido> confirmarPedido({
    required List<PedidoItem> items,
    String? notas,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (items.isEmpty) {
      throw Exception('El pedido no tiene postres');
    }
    if (notas != null && notas.toLowerCase().contains('error')) {
      throw Exception('Error simulado al confirmar pedido');
    }
    final pedido = Pedido(
      id: _sequence++,
      items: items
          .map((e) => PedidoItem(postre: e.postre, cantidad: e.cantidad))
          .toList(),
      cliente:
          items.isNotEmpty ? Cliente(id: 0, nombre: 'Cliente mostrador') : null,
      notas: notas,
      fechaCreacion: DateTime.now(),
    );
    _historial.add(pedido);
    return pedido;
  }

  @override
  Future<List<Pedido>> obtenerHistorial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List<Pedido>.unmodifiable(_historial);
  }
}
