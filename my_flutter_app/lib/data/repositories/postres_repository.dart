import '../models/postre.dart';

abstract class PostresRepository {
  Future<List<Postre>> obtenerTodos();
  Future<Postre?> obtenerPorId(int id);
  Future<Postre> crear({
    required String nombre,
    required double precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  });
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  });
  Future<void> eliminar(int id);
}
