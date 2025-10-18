import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/ingredientes_repository.dart';

import 'package:pitty_app/data/repositories/memory/in_memory_data_source.dart';

class IngredientesRepositoryMem implements IngredientesRepository {
  IngredientesRepositoryMem(this._store);

  final InMemoryDataSource _store;

  @override
  Future<List<Ingrediente>> listar({String? query}) async {
    await _delay();
    Iterable<Ingrediente> result = _store.ingredientes;
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((ingrediente) =>
          ingrediente.nombre.toLowerCase().contains(lower) ||
          ingrediente.unidad.toLowerCase().contains(lower));
    }
    return result.toList();
  }

  @override
  Future<Ingrediente> obtener(int id) async {
    await _delay(short: true);
    return _store.ingredientes.firstWhere((ingrediente) => ingrediente.id == id);
  }

  @override
  Future<Ingrediente> crear({
    required String nombre,
    required String unidad,
    required double stockMinimo,
    required double stockActual,
    required bool activo,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final ingrediente = Ingrediente(
      id: _store.nextIngredienteId(),
      nombre: nombre.trim(),
      unidad: unidad.trim(),
      stockMinimo: stockMinimo,
      stockActual: stockActual,
      activo: activo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _store.ingredientes.add(ingrediente);
    return ingrediente;
  }

  @override
  Future<Ingrediente> actualizar({
    required int id,
    required String nombre,
    required String unidad,
    required double stockMinimo,
    required double stockActual,
    required bool activo,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final index = _store.ingredientes.indexWhere((ingrediente) => ingrediente.id == id);
    if (index == -1) throw Exception('Ingrediente no encontrado');
    final original = _store.ingredientes[index];
    final actualizado = original.copyWith(
      nombre: nombre.trim(),
      unidad: unidad.trim(),
      stockMinimo: stockMinimo,
      stockActual: stockActual,
      activo: activo,
      updatedAt: DateTime.now(),
    );
    _store.ingredientes[index] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    await _delay();
    _store.ingredientes.removeWhere((ingrediente) => ingrediente.id == id);
  }

  Future<void> _delay({bool short = false}) async {
    await Future.delayed(Duration(milliseconds: short ? 180 : 320));
  }
}

