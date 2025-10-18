import 'package:flutter/material.dart';
import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/eventos_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/pedidos_repository.dart';

class EventosProvider extends ChangeNotifier {
  EventosProvider(this._repository, this._pedidosRepository);

  final EventosRepository _repository;
  final PedidosRepository _pedidosRepository;

  final List<Evento> _eventos = [];
  bool _loading = false;
  String? _error;
  String _query = '';
  int _page = 0;
  final int _pageSize = 8;

  bool get loading => _loading;
  String? get error => _error;
  int get page => _page;
  int get totalItems => _eventos.length;
  int get totalPages => totalItems == 0 ? 1 : (totalItems / _pageSize).ceil();

  List<Evento> get pageItems {
    final start = _page * _pageSize;
    return _eventos.skip(start).take(_pageSize).toList();
  }

  Future<void> cargar() async {
    _setLoading(true);
    try {
      final data = await _repository.listar(query: _query);
      _eventos
        ..clear()
        ..addAll(data);
      _error = null;
      _page = 0;
    } catch (error) {
      _error = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void buscar(String value) {
    _query = value;
    cargar();
  }

  void irAPagina(int nuevaPagina) {
    if (nuevaPagina < 0 || nuevaPagina >= totalPages) return;
    _page = nuevaPagina;
    notifyListeners();
  }

  Future<Evento> obtener(int id) => _repository.obtener(id);

  Future<bool> guardar({
    int? id,
    required String titulo,
    String? lugar,
    required DateTime fechaHora,
    int? pedidoId,
    String? notas,
    bool simulateError = false,
  }) async {
    _setLoading(true);
    try {
      if (id == null) {
        await _repository.crear(
          titulo: titulo,
          lugar: lugar,
          fechaHora: fechaHora,
          pedidoId: pedidoId,
          notas: notas,
          simulateError: simulateError,
        );
      } else {
        await _repository.actualizar(
          id: id,
          titulo: titulo,
          lugar: lugar,
          fechaHora: fechaHora,
          pedidoId: pedidoId,
          notas: notas,
          simulateError: simulateError,
        );
      }
      await cargar();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminar(int id) async {
    _setLoading(true);
    try {
      await _repository.eliminar(id);
      await cargar();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Pedido>> listarPedidos() => _pedidosRepository.listar();

  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
