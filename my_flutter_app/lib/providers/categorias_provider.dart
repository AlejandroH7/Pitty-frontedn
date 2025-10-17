import 'package:flutter/foundation.dart';

import '../data/models/categoria.dart';
import '../data/repositories/categorias_repository.dart';

class CategoriasProvider extends ChangeNotifier {
  CategoriasProvider(this._repository);

  final CategoriasRepository _repository;

  final List<Categoria> _categorias = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  List<Categoria> get categorias => List.unmodifiable(_categorias);

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _repository.obtenerTodas();
      _categorias
        ..clear()
        ..addAll(data);
    } catch (e) {
      _error = e.toString();
      _categorias.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> guardar({int? id, required String nombre}) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      if (id == null) {
        final creada = await _repository.crear(nombre: nombre);
        _categorias.add(creada);
      } else {
        final actualizada =
            await _repository.actualizar(id: id, nombre: nombre);
        final index = _categorias.indexWhere((c) => c.id == id);
        if (index != -1) {
          _categorias[index] = actualizada;
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> eliminar(int id) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.eliminar(id);
      _categorias.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Categoria? obtenerPorId(int id) {
    try {
      return _categorias.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
