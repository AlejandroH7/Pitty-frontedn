import 'package:pitty_app/data/models/models.dart';

class InMemoryDataSource {
  InMemoryDataSource() {
    _seedData();
  }

  final List<Cliente> clientes = [];
  final List<Ingrediente> ingredientes = [];
  final List<Postre> postres = [];
  final List<Pedido> pedidos = [];
  final List<Evento> eventos = [];

  int _clienteCounter = 0;
  int _ingredienteCounter = 0;
  int _postreCounter = 0;
  int _pedidoCounter = 0;
  int _eventoCounter = 0;

  int nextClienteId() => ++_clienteCounter;
  int nextIngredienteId() => ++_ingredienteCounter;
  int nextPostreId() => ++_postreCounter;
  int nextPedidoId() => ++_pedidoCounter;
  int nextEventoId() => ++_eventoCounter;

  void _seedData() {
    final now = DateTime.now();

    clientes
      ..clear()
      ..addAll([
        Cliente(
          id: nextClienteId(),
          nombre: 'Ana Perez',
          telefono: '555-1010',
          notas: 'Prefiere entregas por la tarde',
          createdAt: now.subtract(const Duration(days: 20)),
          createdBy: 'sistema',
          updatedAt: now.subtract(const Duration(days: 5)),
          updatedBy: 'admin',
        ),
        Cliente(
          id: nextClienteId(),
          nombre: 'Jorge Ramirez',
          telefono: '555-2222',
          notas: 'Alergico a frutos secos',
          createdAt: now.subtract(const Duration(days: 12)),
          createdBy: 'sistema',
          updatedAt: now.subtract(const Duration(days: 2)),
          updatedBy: 'admin',
        ),
        Cliente(
          id: nextClienteId(),
          nombre: 'Maria Lopez',
          telefono: '555-3030',
          notas: 'Cliente frecuente',
          createdAt: now.subtract(const Duration(days: 8)),
          createdBy: 'sistema',
          updatedAt: now.subtract(const Duration(days: 1)),
          updatedBy: 'admin',
        ),
      ]);

    ingredientes
      ..clear()
      ..addAll([
        Ingrediente(
          id: nextIngredienteId(),
          nombre: 'Harina de trigo',
          unidad: 'kg',
          stockMinimo: 5,
          stockActual: 12,
          activo: true,
          createdAt: now.subtract(const Duration(days: 30)),
          updatedAt: now.subtract(const Duration(days: 3)),
        ),
        Ingrediente(
          id: nextIngredienteId(),
          nombre: 'Cacao en polvo',
          unidad: 'kg',
          stockMinimo: 2,
          stockActual: 4.5,
          activo: true,
          createdAt: now.subtract(const Duration(days: 25)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        Ingrediente(
          id: nextIngredienteId(),
          nombre: 'Azucar',
          unidad: 'kg',
          stockMinimo: 3,
          stockActual: 6,
          activo: true,
          createdAt: now.subtract(const Duration(days: 18)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        Ingrediente(
          id: nextIngredienteId(),
          nombre: 'Fresas',
          unidad: 'kg',
          stockMinimo: 1,
          stockActual: 0.5,
          activo: false,
          createdAt: now.subtract(const Duration(days: 10)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      ]);

    postres
      ..clear()
      ..addAll([
        Postre(
          id: nextPostreId(),
          nombre: 'Pastel de chocolate',
          precio: 45.0,
          porciones: 12,
          activo: true,
          createdAt: now.subtract(const Duration(days: 15)),
          updatedAt: now.subtract(const Duration(days: 2)),
          receta: Receta(
            postreId: 1,
            items: [
              RecetaItem(
                ingredienteId: ingredientes[0].id,
                ingredienteNombre: ingredientes[0].nombre,
                unidad: ingredientes[0].unidad,
                cantidadPorPostre: 1.5,
                mermaPct: 5,
              ),
              RecetaItem(
                ingredienteId: ingredientes[1].id,
                ingredienteNombre: ingredientes[1].nombre,
                unidad: ingredientes[1].unidad,
                cantidadPorPostre: 0.8,
                mermaPct: 3,
              ),
            ],
          ),
        ),
        Postre(
          id: nextPostreId(),
          nombre: 'Cheesecake de frutos rojos',
          precio: 55.0,
          porciones: 10,
          activo: true,
          createdAt: now.subtract(const Duration(days: 11)),
          updatedAt: now.subtract(const Duration(days: 1)),
          receta: Receta(
            postreId: 2,
            items: [
              RecetaItem(
                ingredienteId: ingredientes[0].id,
                ingredienteNombre: ingredientes[0].nombre,
                unidad: ingredientes[0].unidad,
                cantidadPorPostre: 1.0,
                mermaPct: 2,
              ),
              RecetaItem(
                ingredienteId: ingredientes[2].id,
                ingredienteNombre: ingredientes[2].nombre,
                unidad: ingredientes[2].unidad,
                cantidadPorPostre: 0.6,
                mermaPct: 1,
              ),
            ],
          ),
        ),
        Postre(
          id: nextPostreId(),
          nombre: 'Tarta de fresas',
          precio: 38.0,
          porciones: 8,
          activo: false,
          createdAt: now.subtract(const Duration(days: 9)),
          updatedAt: now.subtract(const Duration(days: 1)),
          receta: Receta(
            postreId: 3,
            items: [
              RecetaItem(
                ingredienteId: ingredientes[0].id,
                ingredienteNombre: ingredientes[0].nombre,
                unidad: ingredientes[0].unidad,
                cantidadPorPostre: 0.9,
                mermaPct: 4,
              ),
              RecetaItem(
                ingredienteId: ingredientes[3].id,
                ingredienteNombre: ingredientes[3].nombre,
                unidad: ingredientes[3].unidad,
                cantidadPorPostre: 0.5,
                mermaPct: 15,
              ),
            ],
          ),
        ),
      ]);

    pedidos
      ..clear()
      ..addAll([
        Pedido(
          id: nextPedidoId(),
          clienteId: clientes[0].id,
          clienteNombre: clientes[0].nombre,
          fechaEntrega: now.add(const Duration(days: 2)),
          estado: PedidoEstado.confirmado,
          notas: 'Entregar antes de las 3pm',
          items: [
            PedidoItem(
              postreId: postres[0].id,
              postreNombre: postres[0].nombre,
              cantidad: 1,
              precioUnitario: postres[0].precio,
            ),
            PedidoItem(
              postreId: postres[1].id,
              postreNombre: postres[1].nombre,
              cantidad: 2,
              precioUnitario: postres[1].precio,
            ),
          ],
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        Pedido(
          id: nextPedidoId(),
          clienteId: clientes[1].id,
          clienteNombre: clientes[1].nombre,
          fechaEntrega: now.add(const Duration(days: 5)),
          estado: PedidoEstado.borrador,
          notas: 'Confirmar sabores',
          items: [
            PedidoItem(
              postreId: postres[2].id,
              postreNombre: postres[2].nombre,
              cantidad: 1,
              precioUnitario: postres[2].precio,
            ),
          ],
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ]);

    eventos
      ..clear()
      ..addAll([
        Evento(
          id: nextEventoId(),
          titulo: 'Entrega corporativa',
          lugar: 'Oficinas Central',
          fechaHora: now.add(const Duration(days: 3, hours: 4)),
          pedidoId: pedidos[0].id,
          pedidoCliente: pedidos[0].clienteNombre,
          notas: 'Coordinar acceso con recepcion',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now,
        ),
        Evento(
          id: nextEventoId(),
          titulo: 'Aniversario Maria',
          lugar: 'Salon Azul',
          fechaHora: now.add(const Duration(days: 7, hours: 2)),
          pedidoId: pedidos[1].id,
          pedidoCliente: pedidos[1].clienteNombre,
          notas: 'Confirmar decoracion final',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now,
        ),
      ]);
  }
}
