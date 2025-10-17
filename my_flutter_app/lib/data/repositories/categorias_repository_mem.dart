import 'dart:async';

import '../models/categoria.dart';
import 'categorias_repository.dart';

class CategoriasRepositoryMem implements CategoriasRepository {
  CategoriasRepositoryMem();

  final List<Categoria> _categorias = [
    const Categoria(id: 1, nombre: 'Tortas'),
    const Categoria(id: 2, nombre: 'Postres fríos'),
    const Categoria(id: 3, nombre: 'Galletas'),
  ];
  int _sequence = 4;

  @override
  Future<Categoria> crear({required String nombre}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al crear categoría');
    }
    final nueva = Categoria(id: _sequence++, nombre: nombre.trim());
    _categorias.add(nueva);
    return nueva;
  }

  @override
  Future<void> eliminar(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _categorias.removeWhere((c) => c.id == id);
  }

  @override
  Future<Categoria?> obtenerPorId(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _categorias.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Categoria>> obtenerTodas() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return List<Categoria>.unmodifiable(_categorias);
  }

  @override
  Future<Categoria> actualizar(
      {required int id, required String nombre}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final index = _categorias.indexWhere((c) => c.id == id);
    if (index == -1) {
      throw Exception('Categoría no encontrada');
    }
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al actualizar categoría');
    }
    final actualizada = _categorias[index].copyWith(nombre: nombre.trim());
    _categorias[index] = actualizada;
    return actualizada;
  }
}
