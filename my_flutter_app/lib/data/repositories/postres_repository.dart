import '../models/postre.dart';

abstract class PostresRepository {
  Future<List<Postre>> obtenerTodos();
  Future<Postre?> obtenerPorId(int id);
  Future<Postre> crear({
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
  });
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
  });
  Future<void> eliminar(int id);
}