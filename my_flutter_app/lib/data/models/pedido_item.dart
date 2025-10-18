import 'postre.dart';

class PedidoItem {
  PedidoItem({
    required this.postreId,
    required this.cantidad,
    required this.precioUnitario,
    this.postreNombre,
    this.subtotal,
    this.personalizaciones,
    this.postre,
  });

  final int postreId;
  final String? postreNombre;
  int cantidad;
  double precioUnitario;
  double? subtotal;
  final Map<String, dynamic>? personalizaciones;
  final Postre? postre;

  double get total => subtotal ?? (precioUnitario * cantidad);

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      postreId: (json['postreId'] as num).toInt(),
      postreNombre: json['postreNombre'] as String?,
      cantidad: (json['cantidad'] as num).toInt(),
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      personalizaciones: _parsePersonalizaciones(json['personalizaciones']),
    );
  }

  factory PedidoItem.fromPostre(Postre postre, {int cantidad = 1}) {
    return PedidoItem(
      postreId: postre.id,
      postreNombre: postre.nombre,
      cantidad: cantidad,
      precioUnitario: postre.precio,
      postre: postre,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postreId': postreId,
      if (postreNombre != null) 'postreNombre': postreNombre,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      if (subtotal != null) 'subtotal': subtotal,
      if (personalizaciones != null && personalizaciones!.isNotEmpty)
        'personalizaciones': personalizaciones,
    };
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'postreId': postreId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      if (personalizaciones != null && personalizaciones!.isNotEmpty)
        'personalizaciones': personalizaciones,
    };
  }

  static Map<String, dynamic>? _parsePersonalizaciones(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }
}