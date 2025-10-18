import 'package:pitty_app/data/models/models.dart';

abstract class ClientesRepository {
  Future<List<Cliente>> listar({String? query});
  Future<Cliente> obtener(int id);
  Future<Cliente> crear({
    required String nombre,
    String? telefono,
    String? notas,
    bool simulateError = false,
  });
  Future<Cliente> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? notas,
    bool simulateError = false,
  });
  Future<void> eliminar(int id);
}
