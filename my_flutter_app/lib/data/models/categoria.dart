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
}
