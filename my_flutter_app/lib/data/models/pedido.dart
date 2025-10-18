enum PedidoEstado { borrador, confirmado, entregado, cancelado }

extension PedidoEstadoName on PedidoEstado {
  String get label {
    switch (this) {
      case PedidoEstado.borrador:
        return 'BORRADOR';
      case PedidoEstado.confirmado:
        return 'CONFIRMADO';
      case PedidoEstado.entregado:
        return 'ENTREGADO';
      case PedidoEstado.cancelado:
        return 'CANCELADO';
    }
  }

  static PedidoEstado fromLabel(String label) {
    switch (label) {
      case 'CONFIRMADO':
        return PedidoEstado.confirmado;
      case 'ENTREGADO':
        return PedidoEstado.entregado;
      case 'CANCELADO':
        return PedidoEstado.cancelado;
      default:
        return PedidoEstado.borrador;
    }
  }
}

class PedidoItem {
  const PedidoItem({
    required this.postreId,
    required this.postreNombre,
    required this.cantidad,
    required this.precioUnitario,
    this.personalizaciones,
  });

  final int postreId;
  final String postreNombre;
  final int cantidad;
  final double precioUnitario;
  final Map<String, dynamic>? personalizaciones;

  double get subtotal => cantidad * precioUnitario;

  PedidoItem copyWith({
    int? postreId,
    String? postreNombre,
    int? cantidad,
    double? precioUnitario,
    Map<String, dynamic>? personalizaciones,
  }) {
    return PedidoItem(
      postreId: postreId ?? this.postreId,
      postreNombre: postreNombre ?? this.postreNombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      personalizaciones: personalizaciones ?? this.personalizaciones,
    );
  }
}

class Pedido {
  const Pedido({
    required this.id,
    required this.clienteId,
    required this.clienteNombre,
    required this.fechaEntrega,
    required this.estado,
    this.notas,
    required this.items,
    required this.createdAt,
  });

  final int id;
  final int clienteId;
  final String clienteNombre;
  final DateTime fechaEntrega;
  final PedidoEstado estado;
  final String? notas;
  final List<PedidoItem> items;
  final DateTime createdAt;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  Pedido copyWith({
    int? id,
    int? clienteId,
    String? clienteNombre,
    DateTime? fechaEntrega,
    PedidoEstado? estado,
    String? notas,
    List<PedidoItem>? items,
    DateTime? createdAt,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
