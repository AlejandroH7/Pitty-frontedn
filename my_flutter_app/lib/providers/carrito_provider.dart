import 'package:flutter/foundation.dart';

import '../data/models/pedido_item.dart';
import '../data/models/postre.dart';
import '../data/repositories/pedidos_repository.dart';

class CarritoProvider extends ChangeNotifier {
  CarritoProvider(this._repository);

  final PedidosRepository _repository;

  final Map<int, PedidoItem> _items = {};
  bool _isProcessing = false;
  String? _error;
  String? _ultimoMensaje;

  List<PedidoItem> get items => _items.values.toList(growable: false);
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  String? get ultimoMensaje => _ultimoMensaje;
  int get totalCantidad =>
      _items.values.fold(0, (value, item) => value + item.cantidad);
  double get total =>
      _items.values.fold(0, (value, item) => value + item.total);

  void agregarPostre(Postre postre) {
    final existente = _items[postre.id];
    if (existente == null) {
      _items[postre.id] = PedidoItem.fromPostre(postre);
    } else {
      existente.cantidad += 1;
    }
    notifyListeners();
  }

  void actualizarCantidad(Postre postre, int cantidad) {
    if (cantidad <= 0) {
      _items.remove(postre.id);
    } else {
      _items[postre.id] = PedidoItem.fromPostre(
        postre,
        cantidad: cantidad,
      );
    }
    notifyListeners();
  }

  void eliminarPostre(int postreId) {
    _items.remove(postreId);
    notifyListeners();
  }

  void limpiar() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> confirmarPedido({
    String? notas,
    int? clienteId,
    DateTime? fechaEntrega,
  }) async {
    if (_items.isEmpty) {
      _error = 'Agrega al menos un postre al carrito';
      notifyListeners();
      return false;
    }
    _isProcessing = true;
    _error = null;
    _ultimoMensaje = null;
    notifyListeners();
    final notasValue = notas?.trim();
    try {
      final pedido = await _repository.confirmarPedido(
        items: items,
        notas: (notasValue == null || notasValue.isEmpty) ? null : notasValue,
        clienteId: clienteId,
        fechaEntrega: fechaEntrega,
      );
      _ultimoMensaje =
          'Pedido #${pedido.id} creado (${pedido.estado.toLowerCase()})';
      limpiar();
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isProcessing = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}