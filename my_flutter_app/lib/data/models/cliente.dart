class Cliente {
  const Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    this.notas,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  final int id;
  final String nombre;
  final String? telefono;
  final String? notas;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  Cliente copyWith({
    int? id,
    String? nombre,
    String? telefono,
    String? notas,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      notas: json['notas'] as String?,
      createdAt: _parseDate(json['createdAt']),
      createdBy: json['createdBy'] as String?,
      updatedAt: _parseDate(json['updatedAt']),
      updatedBy: json['updatedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson({bool includeAudit = true}) {
    final map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (notas != null) 'notas': notas,
    };
    if (includeAudit) {
      if (createdAt != null) {
        map['createdAt'] = createdAt!.toIso8601String();
      }
      if (createdBy != null) {
        map['createdBy'] = createdBy;
      }
      if (updatedAt != null) {
        map['updatedAt'] = updatedAt!.toIso8601String();
      }
      if (updatedBy != null) {
        map['updatedBy'] = updatedBy;
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