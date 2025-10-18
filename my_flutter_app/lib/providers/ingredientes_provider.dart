import 'package:flutter/material.dart';
import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/ingredientes_repository.dart';

class IngredientesProvider extends ChangeNotifier {
  IngredientesProvider(this._repository);

  final IngredientesRepository _repository;

  final List<Ingrediente> _ingredientes = [];
  bool _loading = false;
  String? _error;
  String _query = '';
  int _page = 0;
  final int _pageSize = 8;

  bool get loading => _loading;
  String? get error => _error;
  int get page => _page;
  int get totalItems => _ingredientes.length;
  int get totalPages => totalItems == 0 ? 1 : (totalItems / _pageSize).ceil();

  List<Ingrediente> get pageItems {
    final start = _page * _pageSize;
    return _ingredientes.skip(start).take(_pageSize).toList();
  }

  Future<void> cargar() async {
    _setLoading(true);
    try {
      final data = await _repository.listar(query: _query);
      _ingredientes
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

  Future<Ingrediente> obtener(int id) => _repository.obtener(id);

  Future<bool> guardar({
    int? id,
    required String nombre,
    required String unidad,
    required double stockMinimo,
    required double stockActual,
    required bool activo,
    bool simulateError = false,
  }) async {
    _setLoading(true);
    try {
      if (id == null) {
        await _repository.crear(
          nombre: nombre,
          unidad: unidad,
          stockMinimo: stockMinimo,
          stockActual: stockActual,
          activo: activo,
          simulateError: simulateError,
        );
      } else {
        await _repository.actualizar(
          id: id,
          nombre: nombre,
          unidad: unidad,
          stockMinimo: stockMinimo,
          stockActual: stockActual,
          activo: activo,
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

  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
