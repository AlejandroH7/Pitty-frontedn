import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/clientes_repository.dart';

import 'package:pitty_app/data/repositories/memory/in_memory_data_source.dart';

class ClientesRepositoryMem implements ClientesRepository {
  ClientesRepositoryMem(this._store);

  final InMemoryDataSource _store;

  @override
  Future<List<Cliente>> listar({String? query}) async {
    await _delay();
    Iterable<Cliente> result = _store.clientes;
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((cliente) =>
          cliente.nombre.toLowerCase().contains(lower) ||
          (cliente.telefono ?? '').toLowerCase().contains(lower));
    }
    return result.toList();
  }

  @override
  Future<Cliente> obtener(int id) async {
    await _delay(short: true);
    return _store.clientes.firstWhere((cliente) => cliente.id == id);
  }

  @override
  Future<Cliente> crear({
    required String nombre,
    String? telefono,
    String? notas,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final now = DateTime.now();
    final nuevo = Cliente(
      id: _store.nextClienteId(),
      nombre: nombre.trim(),
      telefono: telefono?.trim(),
      notas: notas?.trim(),
      createdAt: now,
      createdBy: 'usuario',
      updatedAt: now,
      updatedBy: 'usuario',
    );
    _store.clientes.add(nuevo);
    return nuevo;
  }

  @override
  Future<Cliente> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? notas,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final index = _store.clientes.indexWhere((cliente) => cliente.id == id);
    if (index == -1) throw Exception('Cliente no encontrado');
    final actual = _store.clientes[index];
    final actualizado = actual.copyWith(
      nombre: nombre.trim(),
      telefono: telefono?.trim(),
      notas: notas?.trim(),
      updatedAt: DateTime.now(),
      updatedBy: 'usuario',
    );
    _store.clientes[index] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    await _delay();
    _store.clientes.removeWhere((cliente) => cliente.id == id);
  }

  Future<void> _delay({bool short = false}) async {
    await Future.delayed(Duration(milliseconds: short ? 200 : 350));
  }
}

