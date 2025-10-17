import 'dart:async';

import '../models/postre.dart';
import 'postres_repository.dart';

class PostresRepositoryMem implements PostresRepository {
  PostresRepositoryMem();

  final List<Postre> _postres = [
    const Postre(
      id: 1,
      nombre: 'Chocotorta',
      precio: 30,
      categoriaId: 1,
      descripcion: 'Clásica torta fría de chocolate',
    ),
    const Postre(
      id: 2,
      nombre: 'Lemon Pie',
      precio: 25,
      categoriaId: 2,
      descripcion: 'Pie de limón con merengue',
    ),
    const Postre(
      id: 3,
      nombre: 'Galletas de avena',
      precio: 12,
      categoriaId: 3,
      descripcion: 'Docena de galletas con chips de chocolate',
    ),
  ];
  int _sequence = 4;

  @override
  Future<Postre> crear({
    required String nombre,
    required double precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al crear postre');
    }
    final nuevo = Postre(
      id: _sequence++,
      nombre: nombre.trim(),
      precio: precio,
      categoriaId: categoriaId,
      descripcion:
          descripcion?.trim().isEmpty ?? true ? null : descripcion?.trim(),
      imagenUrl: imagenUrl?.trim().isEmpty ?? true ? null : imagenUrl?.trim(),
    );
    _postres.add(nuevo);
    return nuevo;
  }

  @override
  Future<void> eliminar(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _postres.removeWhere((p) => p.id == id);
  }

  @override
  Future<Postre?> obtenerPorId(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return _postres.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Postre>> obtenerTodos() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return List<Postre>.unmodifiable(_postres);
  }

  @override
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    final index = _postres.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Postre no encontrado');
    }
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al actualizar postre');
    }
    final actualizado = _postres[index].copyWith(
      nombre: nombre.trim(),
      precio: precio,
      categoriaId: categoriaId,
      descripcion:
          descripcion?.trim().isEmpty ?? true ? null : descripcion?.trim(),
      imagenUrl: imagenUrl?.trim().isEmpty ?? true ? null : imagenUrl?.trim(),
    );
    _postres[index] = actualizado;
    return actualizado;
  }
}
