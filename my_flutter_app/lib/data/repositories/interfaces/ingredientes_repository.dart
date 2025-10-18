import 'package:pitty_app/data/models/models.dart';

abstract class IngredientesRepository {
  Future<List<Ingrediente>> listar({String? query});
  Future<Ingrediente> obtener(int id);
  Future<Ingrediente> crear({
    required String nombre,
    required String unidad,
    required double stockMinimo,
    required double stockActual,
    required bool activo,
    bool simulateError = false,
  });
  Future<Ingrediente> actualizar({
    required int id,
    required String nombre,
    required String unidad,
    required double stockMinimo,
    required double stockActual,
    required bool activo,
    bool simulateError = false,
  });
  Future<void> eliminar(int id);
}
