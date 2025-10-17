import 'package:flutter/foundation.dart';

import '../data/models/postre.dart';
import '../data/repositories/postres_repository.dart';

class PostresProvider extends ChangeNotifier {
  PostresProvider(this._repository);

  final PostresRepository _repository;

  final List<Postre> _postres = [];
  List<Postre> _filtrados = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  String _search = '';
  int _currentPage = 0;
  static const int _pageSize = 8;
  int _totalFiltrados = 0;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  List<Postre> get postres => List.unmodifiable(_filtrados);
  int get currentPage => _currentPage;
  bool get hasNextPage => ((_currentPage + 1) * _pageSize) < _totalFiltrados;
  bool get hasPreviousPage => _currentPage > 0;
  int get totalPages => (_totalFiltrados / _pageSize).ceil().clamp(1, 999);

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _repository.obtenerTodos();
      _postres
        ..clear()
        ..addAll(data);
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      _filtrados = [];
      _totalFiltrados = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void buscar(String value) {
    _search = value.trim();
    _currentPage = 0;
    _applyFilters();
    notifyListeners();
  }

  void nextPage() {
    if (!hasNextPage) return;
    _currentPage++;
    _applyFilters();
    notifyListeners();
  }

  void previousPage() {
    if (!hasPreviousPage) return;
    _currentPage--;
    _applyFilters();
    notifyListeners();
  }

  Future<bool> guardar({
    int? id,
    required String nombre,
    required double precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      if (id == null) {
        final creado = await _repository.crear(
          nombre: nombre,
          precio: precio,
          categoriaId: categoriaId,
          descripcion: descripcion,
          imagenUrl: imagenUrl,
        );
        _postres.add(creado);
      } else {
        final actualizado = await _repository.actualizar(
          id: id,
          nombre: nombre,
          precio: precio,
          categoriaId: categoriaId,
          descripcion: descripcion,
          imagenUrl: imagenUrl,
        );
        final index = _postres.indexWhere((p) => p.id == id);
        if (index != -1) {
          _postres[index] = actualizado;
        }
      }
      _applyFilters();
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
      _postres.removeWhere((p) => p.id == id);
      _applyFilters();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Postre? obtenerPorId(int id) {
    try {
      return _postres.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void _applyFilters() {
    Iterable<Postre> resultado = _postres;
    if (_search.isNotEmpty) {
      resultado = resultado.where(
        (p) => p.nombre.toLowerCase().contains(_search.toLowerCase()),
      );
    }
    final lista = resultado.toList();
    _totalFiltrados = lista.length;
    final start = (_currentPage * _pageSize).clamp(0, lista.length);
    var end = start + _pageSize;
    if (end > lista.length) {
      end = lista.length;
    }
    _filtrados = lista.sublist(start, end);
  }
}
