import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/eventos_repository.dart';

import 'in_memory_data_source.dart';

class EventosRepositoryMem implements EventosRepository {
  EventosRepositoryMem(this._store);

  final InMemoryDataSource _store;

  @override
  Future<List<Evento>> listar({String? query}) async {
    await _delay();
    Iterable<Evento> result = _store.eventos;
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((evento) => evento.titulo.toLowerCase().contains(lower));
    }
    final list = result.toList();
    list.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
    return list;
  }

  @override
  Future<Evento> obtener(int id) async {
    await _delay(short: true);
    return _store.eventos.firstWhere((evento) => evento.id == id);
  }

  @override
  Future<Evento> crear({
    required String titulo,
    String? lugar,
    required DateTime fechaHora,
    int? pedidoId,
    String? notas,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final pedidoCliente = pedidoId != null
        ? _store.pedidos.firstWhere((pedido) => pedido.id == pedidoId).clienteNombre
        : null;
    final evento = Evento(
      id: _store.nextEventoId(),
      titulo: titulo.trim(),
      lugar: lugar?.trim(),
      fechaHora: fechaHora,
      pedidoId: pedidoId,
      pedidoCliente: pedidoCliente,
      notas: notas?.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _store.eventos.add(evento);
    return evento;
  }

  @override
  Future<Evento> actualizar({
    required int id,
    required String titulo,
    String? lugar,
    required DateTime fechaHora,
    int? pedidoId,
    String? notas,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final index = _store.eventos.indexWhere((evento) => evento.id == id);
    if (index == -1) throw Exception('Evento no encontrado');
    final pedidoCliente = pedidoId != null
        ? _store.pedidos.firstWhere((pedido) => pedido.id == pedidoId).clienteNombre
        : null;
    final original = _store.eventos[index];
    final actualizado = original.copyWith(
      titulo: titulo.trim(),
      lugar: lugar?.trim(),
      fechaHora: fechaHora,
      pedidoId: pedidoId,
      pedidoCliente: pedidoCliente,
      notas: notas?.trim(),
      updatedAt: DateTime.now(),
    );
    _store.eventos[index] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    await _delay();
    _store.eventos.removeWhere((evento) => evento.id == id);
  }

  Future<void> _delay({bool short = false}) async {
    await Future.delayed(Duration(milliseconds: short ? 180 : 320));
  }
}
