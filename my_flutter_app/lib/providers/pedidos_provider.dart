import 'package:flutter/material.dart';
import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/data/repositories/interfaces/clientes_repository.dart';
import 'package:pitty_app/data/repositories/pedido_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/postres_repository.dart';

class PedidosProvider extends ChangeNotifier {
  PedidosProvider(this._repository, this._clientesRepository, this._postresRepository);

  final PedidoRepository _repository;
  final ClientesRepository _clientesRepository;
  final PostresRepository _postresRepository;

  final List<Pedido> _pedidos = [];
  bool _loading = false;
  String? _error;
  String _query = '';
  DateTime? _desde;
  DateTime? _hasta;
  int _page = 0;
  final int _pageSize = 6;

  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;
  DateTime? get desde => _desde;
  DateTime? get hasta => _hasta;
  int get page => _page;
  int get totalItems => _pedidos.length;
  int get totalPages => totalItems == 0 ? 1 : (totalItems / _pageSize).ceil();

  List<Pedido> get pageItems {
    final start = _page * _pageSize;
    return _pedidos.skip(start).take(_pageSize).toList();
  }

  Future<void> cargar() async {
    _setLoading(true);
    try {
      final data = await _repository.listar(query: _query, desde: _desde, hasta: _hasta);
      _pedidos
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

  void actualizarRango({DateTime? desde, DateTime? hasta}) {
    _desde = desde;
    _hasta = hasta;
    cargar();
  }

  void irAPagina(int nuevaPagina) {
    if (nuevaPagina < 0 || nuevaPagina >= totalPages) return;
    _page = nuevaPagina;
    notifyListeners();
  }

  Future<Pedido> obtener(int id) => _repository.obtener(id);

  Future<bool> crear({
    required int clienteId,
    required DateTime fechaEntrega,
    String? notas,
    required List<PedidoItemInput> items,
    bool simulateError = false,
  }) async {
    _setLoading(true);
    try {
      await _repository.crear(
        clienteId: clienteId,
        fechaEntrega: fechaEntrega,
        notas: notas,
        items: items,
        simulateError: simulateError,
      );
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

  Future<bool> actualizarEstado({
    required int id,
    required PedidoEstado estado,
    bool simulateError = false,
  }) async {
    _setLoading(true);
    try {
      await _repository.actualizarEstado(
        id: id,
        estado: estado,
        simulateError: simulateError,
      );
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

  Future<List<Cliente>> listarClientes() => _clientesRepository.listar();
  Future<List<Postre>> listarPostres() => _postresRepository.listar();

  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}

