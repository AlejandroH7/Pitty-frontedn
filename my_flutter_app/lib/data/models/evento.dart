class Evento {
  const Evento({
    required this.id,
    required this.titulo,
    this.lugar,
    required this.fechaHora,
    this.pedidoId,
    this.pedidoCliente,
    this.notas,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String titulo;
  final String? lugar;
  final DateTime fechaHora;
  final int? pedidoId;
  final String? pedidoCliente;
  final String? notas;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Evento copyWith({
    int? id,
    String? titulo,
    String? lugar,
    DateTime? fechaHora,
    int? pedidoId,
    String? pedidoCliente,
    String? notas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Evento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      lugar: lugar ?? this.lugar,
      fechaHora: fechaHora ?? this.fechaHora,
      pedidoId: pedidoId ?? this.pedidoId,
      pedidoCliente: pedidoCliente ?? this.pedidoCliente,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
