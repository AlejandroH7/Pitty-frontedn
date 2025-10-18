import '../models/cliente.dart';

abstract class ClientesRepository {
  Future<List<Cliente>> obtenerTodos();
  Future<Cliente?> obtenerPorId(int id);
  Future<Cliente> crear({
    required String nombre,
    String? telefono,
    String? notas,
  });
  Future<Cliente> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? notas,
  });
  Future<void> eliminar(int id);
}