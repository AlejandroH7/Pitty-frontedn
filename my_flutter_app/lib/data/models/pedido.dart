import 'pedido_item.dart';

class Pedido {
  const Pedido({
    required this.id,
    this.clienteId,
    this.clienteNombre,
    required this.fechaEntrega,
    required this.estado,
    this.notas,
    required this.total,
    required this.items,
  });

  final int id;
  final int? clienteId;
  final String? clienteNombre;
  final DateTime fechaEntrega;
  final String estado;
  final String? notas;
  final double total;
  final List<PedidoItem> items;

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: (json['id'] as num).toInt(),
      clienteId: (json['clienteId'] as num?)?.toInt(),
      clienteNombre: json['clienteNombre'] as String?,
      fechaEntrega: DateTime.parse(json['fechaEntrega'] as String),
      estado: json['estado'] as String,
      notas: json['notas'] as String?,
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(PedidoItem.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson({bool includeItems = true}) {
    final map = <String, dynamic>{
      'id': id,
      if (clienteId != null) 'clienteId': clienteId,
      if (clienteNombre != null) 'clienteNombre': clienteNombre,
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'estado': estado,
      if (notas != null) 'notas': notas,
      'total': total,
    };
    if (includeItems) {
      map['items'] = items.map((item) => item.toJson()).toList();
    }
    return map;
  }
}