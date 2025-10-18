import 'dart:async';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/recetas_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/ingredientes_repository.dart';

import 'in_memory_data_source.dart';

class RecetasRepositoryMem implements RecetasRepository {
  RecetasRepositoryMem(this._store, this._ingredientesRepository);

  final InMemoryDataSource _store;
  final IngredientesRepository _ingredientesRepository;

  @override
  Future<Receta> obtenerPorPostre(int postreId) async {
    await _delay();
    final postre = _store.postres.firstWhere((element) => element.id == postreId);
    final recetaExistente = postre.receta;
    if (recetaExistente != null) {
      return recetaExistente;
    }
    final receta = Receta(postreId: postreId, items: const []);
    _actualizarReceta(postreId, receta);
    return receta;
  }

  @override
  Future<Receta> reemplazar(int postreId, List<RecetaItem> items, {bool simulateError = false}) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final actualizados = await _enriquecer(items);
    final receta = Receta(postreId: postreId, items: actualizados);
    _actualizarReceta(postreId, receta);
    return receta;
  }

  @override
  Future<Receta> agregarOActualizar({
    required int postreId,
    required RecetaItem item,
    bool simulateError = false,
  }) async {
    await _delay();
    if (simulateError) throw Exception('Error (simulado)');
    final receta = await obtenerPorPostre(postreId);
    final items = [...receta.items];
    final enriched = await _enriquecer([item]);
    final enrichedItem = enriched.first;
    final index = items.indexWhere((element) => element.ingredienteId == enrichedItem.ingredienteId);
    if (index >= 0) {
      items[index] = enrichedItem;
    } else {
      items.add(enrichedItem);
    }
    final actualizada = Receta(postreId: postreId, items: items);
    _actualizarReceta(postreId, actualizada);
    return actualizada;
  }

  @override
  Future<void> eliminarItem(int postreId, int ingredienteId) async {
    await _delay();
    final receta = await obtenerPorPostre(postreId);
    final items = receta.items.where((item) => item.ingredienteId != ingredienteId).toList();
    final actualizada = Receta(postreId: postreId, items: items);
    _actualizarReceta(postreId, actualizada);
  }

  Future<List<RecetaItem>> _enriquecer(List<RecetaItem> items) async {
    final enriched = <RecetaItem>[];
    for (final item in items) {
      final ingrediente = await _ingredientesRepository.obtener(item.ingredienteId);
      enriched.add(item.copyWith(
        ingredienteNombre: ingrediente.nombre,
        unidad: ingrediente.unidad,
      ));
    }
    return enriched;
  }

  void _actualizarReceta(int postreId, Receta receta) {
    final index = _store.postres.indexWhere((postre) => postre.id == postreId);
    if (index == -1) throw Exception('Postre no encontrado');
    final original = _store.postres[index];
    _store.postres[index] = original.copyWith(receta: receta, updatedAt: DateTime.now());
  }

  Future<void> _delay() async {
    await Future.delayed(const Duration(milliseconds: 250));
  }
}
