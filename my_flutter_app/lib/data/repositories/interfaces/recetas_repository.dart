import 'package:pitty_app/data/models/models.dart';

abstract class RecetasRepository {
  Future<Receta> obtenerPorPostre(int postreId);
  Future<Receta> reemplazar(int postreId, List<RecetaItem> items, {bool simulateError = false});
  Future<Receta> agregarOActualizar({
    required int postreId,
    required RecetaItem item,
    bool simulateError = false,
  });
  Future<void> eliminarItem(int postreId, int ingredienteId);
}
