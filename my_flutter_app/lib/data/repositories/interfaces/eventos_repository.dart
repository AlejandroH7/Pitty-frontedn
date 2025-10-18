import 'package:pitty_app/data/models/models.dart';

abstract class EventosRepository {
  Future<List<Evento>> listar({String? query});
  Future<Evento> obtener(int id);
  Future<Evento> crear({
    required String titulo,
    String? lugar,
    required DateTime fechaHora,
    int? pedidoId,
    String? notas,
    bool simulateError = false,
  });
  Future<Evento> actualizar({
    required int id,
    required String titulo,
    String? lugar,
    required DateTime fechaHora,
    int? pedidoId,
    String? notas,
    bool simulateError = false,
  });
  Future<void> eliminar(int id);
}
