import 'package:flutter/foundation.dart';

import '../data/models/cliente.dart';
import '../data/repositories/clientes_repository.dart';

class ClientesProvider extends ChangeNotifier {
  ClientesProvider(this._repository);

  final ClientesRepository _repository;

  final List<Cliente> _clientes = [];
  List<Cliente> _filtrados = [];
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
  List<Cliente> get clientes => List.unmodifiable(_filtrados);
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasNextPage => ((_currentPage + 1) * _pageSize) < _totalFiltrados;
  bool get hasPreviousPage => _currentPage > 0;
  int get totalPages => (_totalFiltrados / _pageSize).ceil().clamp(1, 999);
  String get search => _search;

  Future<void> loadClientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final todos = await _repository.obtenerTodos();
      _clientes
        ..clear()
        ..addAll(todos);
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
    String? telefono,
    String? correo,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      if (id == null) {
        final creado = await _repository.crear(
          nombre: nombre,
          telefono: telefono,
          correo: correo,
        );
        _clientes.add(creado);
      } else {
        final actualizado = await _repository.actualizar(
          id: id,
          nombre: nombre,
          telefono: telefono,
          correo: correo,
        );
        final index = _clientes.indexWhere((c) => c.id == id);
        if (index != -1) {
          _clientes[index] = actualizado;
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
      _clientes.removeWhere((c) => c.id == id);
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

  Cliente? obtenerPorId(int id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void _applyFilters() {
    Iterable<Cliente> resultado = _clientes;
    if (_search.isNotEmpty) {
      resultado = resultado.where(
        (c) => c.nombre.toLowerCase().contains(_search.toLowerCase()),
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
