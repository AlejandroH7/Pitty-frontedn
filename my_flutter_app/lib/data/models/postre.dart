import 'package:pitty_app/data/models/receta.dart';

class Postre {
  const Postre({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.porciones,
    required this.activo,
    required this.createdAt,
    this.updatedAt,
    this.receta,
  });

  final int id;
  final String nombre;
  final double precio;
  final int porciones;
  final bool activo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Receta? receta;

  Postre copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? porciones,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Receta? receta,
  }) {
    return Postre(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      porciones: porciones ?? this.porciones,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      receta: receta ?? this.receta,
    );
  }
}

