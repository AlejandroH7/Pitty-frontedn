class Ingrediente {
  const Ingrediente({
    required this.id,
    required this.nombre,
    required this.unidad,
    required this.stockMinimo,
    required this.stockActual,
    required this.activo,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String nombre;
  final String unidad;
  final double stockMinimo;
  final double stockActual;
  final bool activo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Ingrediente copyWith({
    int? id,
    String? nombre,
    String? unidad,
    double? stockMinimo,
    double? stockActual,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ingrediente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      unidad: unidad ?? this.unidad,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      stockActual: stockActual ?? this.stockActual,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
