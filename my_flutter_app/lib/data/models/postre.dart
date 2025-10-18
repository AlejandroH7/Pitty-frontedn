class Postre {
  const Postre({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.porciones,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String nombre;
  final double precio;
  final int porciones;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Postre copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? porciones,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Postre(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      porciones: porciones ?? this.porciones,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Postre.fromJson(Map<String, dynamic> json) {
    return Postre(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      porciones: (json['porciones'] as num).toInt(),
      activo: json['activo'] as bool? ?? false,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({bool includeAudit = true}) {
    final map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'porciones': porciones,
      'activo': activo,
    };
    if (includeAudit) {
      if (createdAt != null) {
        map['createdAt'] = createdAt!.toIso8601String();
      }
      if (updatedAt != null) {
        map['updatedAt'] = updatedAt!.toIso8601String();
      }
    }
    return map;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}