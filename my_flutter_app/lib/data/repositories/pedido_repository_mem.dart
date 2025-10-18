import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/memory/in_memory_data_source.dart';
import 'package:pitty_app/data/repositories/pedido_repository.dart';

class PedidoRepositoryMem implements PedidoRepository {
  PedidoRepositoryMem([InMemoryDataSource? store]) : _store = store ?? InMemoryDataSource();

  final InMemoryDataSource _store;

  @override
  Future<List<Pedido>> listar({String? query, DateTime? desde, DateTime? hasta}) async {
    await _delay();
    Iterable<Pedido> result = _store.pedidos;
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((pedido) =>
          pedido.clienteNombre.toLowerCase().contains(lower) ||
          pedido.estado.label.toLowerCase().contains(lower));
    }
    if (desde != null) {
      result = result.where((pedido) => !pedido.fechaEntrega.isBefore(desde));
    }
    if (hasta != null) {
      result = result.where((pedido) => !pedido.fechaEntrega.isAfter(hasta));
    }
    final list = result.toList();
    list.sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
    return list;
  }

  @override
  Future<Pedido> obtener(int id) async {
    await _delay(short: true);
    return _store.pedidos.firstWhere((pedido) => pedido.id == id);
  }

  @override
  Future<Pedido> crear({
    required int clienteId,
    required DateTime fechaEntrega,
    String? notas,
    required List<PedidoItemInput> items,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final cliente = _store.clientes.firstWhere((element) => element.id == clienteId);
    final itemList = items.map(_mapItem).toList();
    final pedido = Pedido(
      id: _store.nextPedidoId(),
      clienteId: cliente.id,
      clienteNombre: cliente.nombre,
      fechaEntrega: fechaEntrega,
      estado: PedidoEstado.borrador,
      notas: notas?.trim(),
      items: itemList,
      createdAt: DateTime.now(),
    );
    _store.pedidos.add(pedido);
    return pedido;
  }

  @override
  Future<Pedido> actualizarEstado({
    required int id,
    required PedidoEstado estado,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final index = _store.pedidos.indexWhere((pedido) => pedido.id == id);
    if (index == -1) throw Exception('Pedido no encontrado');
    final original = _store.pedidos[index];
    final actualizado = original.copyWith(estado: estado);
    _store.pedidos[index] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    await _delay();
    _store.pedidos.removeWhere((pedido) => pedido.id == id);
  }

  PedidoItem _mapItem(PedidoItemInput input) {
    final postre = _store.postres.firstWhere((element) => element.id == input.postreId);
    return PedidoItem(
      postreId: postre.id,
      postreNombre: postre.nombre,
      cantidad: input.cantidad,
      precioUnitario: input.precioUnitario,
      personalizaciones: input.personalizaciones,
    );
  }

  Future<void> _delay({bool short = false}) async {
    await Future.delayed(Duration(milliseconds: short ? 180 : 330));
  }
}
