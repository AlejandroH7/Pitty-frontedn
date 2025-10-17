class Postre {
  const Postre({
    required this.id,
    required this.nombre,
    required this.precio,
    this.categoriaId,
    this.descripcion,
    this.imagenUrl,
  });

  final int id;
  final String nombre;
  final double precio;
  final int? categoriaId;
  final String? descripcion;
  final String? imagenUrl;

  Postre copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? categoriaId,
    String? descripcion,
    String? imagenUrl,
  }) {
    return Postre(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      categoriaId: categoriaId ?? this.categoriaId,
      descripcion: descripcion ?? this.descripcion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }
}
