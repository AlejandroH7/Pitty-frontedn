class RecetaItem {
  const RecetaItem({
    required this.ingredienteId,
    required this.ingredienteNombre,
    required this.unidad,
    required this.cantidadPorPostre,
    required this.mermaPct,
  });

  final int ingredienteId;
  final String ingredienteNombre;
  final String unidad;
  final double cantidadPorPostre;
  final double mermaPct;

  RecetaItem copyWith({
    int? ingredienteId,
    String? ingredienteNombre,
    String? unidad,
    double? cantidadPorPostre,
    double? mermaPct,
  }) {
    return RecetaItem(
      ingredienteId: ingredienteId ?? this.ingredienteId,
      ingredienteNombre: ingredienteNombre ?? this.ingredienteNombre,
      unidad: unidad ?? this.unidad,
      cantidadPorPostre: cantidadPorPostre ?? this.cantidadPorPostre,
      mermaPct: mermaPct ?? this.mermaPct,
    );
  }
}

class Receta {
  const Receta({required this.postreId, required this.items});

  final int postreId;
  final List<RecetaItem> items;

  Receta copyWith({int? postreId, List<RecetaItem>? items}) {
    return Receta(
      postreId: postreId ?? this.postreId,
      items: items ?? this.items,
    );
  }
}
