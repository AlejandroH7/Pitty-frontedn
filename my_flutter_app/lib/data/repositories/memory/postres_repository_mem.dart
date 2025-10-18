import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/postres_repository.dart';

import 'package:pitty_app/data/repositories/memory/in_memory_data_source.dart';

class PostresRepositoryMem implements PostresRepository {
  PostresRepositoryMem(this._store);

  final InMemoryDataSource _store;

  @override
  Future<List<Postre>> listar({String? query}) async {
    await _delay();
    Iterable<Postre> result = _store.postres;
    if (query != null && query.trim().isNotEmpty) {
      final lower = query.toLowerCase();
      result = result.where((postre) => postre.nombre.toLowerCase().contains(lower));
    }
    return result.toList();
  }

  @override
  Future<Postre> obtener(int id) async {
    await _delay(short: true);
    return _store.postres.firstWhere((postre) => postre.id == id);
  }

  @override
  Future<Postre> crear({
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final id = _store.nextPostreId();
    final postre = Postre(
      id: id,
      nombre: nombre.trim(),
      precio: precio,
      porciones: porciones,
      activo: activo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      receta: Receta(postreId: id, items: const []),
    );
    _store.postres.add(postre);
    return postre;
  }

  @override
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final index = _store.postres.indexWhere((postre) => postre.id == id);
    if (index == -1) throw Exception('Postre no encontrado');
    final original = _store.postres[index];
    final actualizado = original.copyWith(
      nombre: nombre.trim(),
      precio: precio,
      porciones: porciones,
      activo: activo,
      updatedAt: DateTime.now(),
    );
    _store.postres[index] = actualizado;
    return actualizado;
  }

  @override
  Future<void> eliminar(int id) async {
    await _delay();
    _store.postres.removeWhere((postre) => postre.id == id);
    for (final pedido in _store.pedidos) {
      pedido.items.removeWhere((item) => item.postreId == id);
    }
  }

  Future<void> _delay({bool short = false}) async {
    await Future.delayed(Duration(milliseconds: short ? 180 : 320));
  }
}

