class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
  });

  final int id;
  final String nombre;

  Categoria copyWith({
    int? id,
    String? nombre,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}