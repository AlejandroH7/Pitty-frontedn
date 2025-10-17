import '../models/categoria.dart';

abstract class CategoriasRepository {
  Future<List<Categoria>> obtenerTodas();
  Future<Categoria?> obtenerPorId(int id);
  Future<Categoria> crear({required String nombre});
  Future<Categoria> actualizar({required int id, required String nombre});
  Future<void> eliminar(int id);
}
