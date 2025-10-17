class Cliente {
  const Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    this.correo,
  });

  final int id;
  final String nombre;
  final String? telefono;
  final String? correo;

  Cliente copyWith({
    int? id,
    String? nombre,
    String? telefono,
    String? correo,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
    );
  }
}
