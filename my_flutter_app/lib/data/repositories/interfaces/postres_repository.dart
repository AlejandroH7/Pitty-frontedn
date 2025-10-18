import 'package:pitty_app/data/models/models.dart';

abstract class PostresRepository {
  Future<List<Postre>> listar({String? query});
  Future<Postre> obtener(int id);
  Future<Postre> crear({
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
    bool simulateError = false,
  });
  Future<Postre> actualizar({
    required int id,
    required String nombre,
    required double precio,
    required int porciones,
    required bool activo,
    bool simulateError = false,
  });
  Future<void> eliminar(int id);
}
