# Pitty Frontend (Flutter)

Frontend Flutter 3 que replica en memoria los recursos del backend Spring Boot de Pitty. Toda la informacion se maneja con listas mock y `provider` como gestor de estado.

## Requisitos
- Flutter 3.x con null-safety.
- Dart SDK >=3.0.0 <4.0.0.

## Como ejecutar
```bash
flutter clean
flutter pub get
flutter run
```

## Recursos cubiertos
Los controladores REST del backend (Clientes, Ingredientes, Postres, Recetas, Pedidos y Eventos) se reflejan en las siguientes pantallas:

| Recurso | Pantallas | Detalle |
| --- | --- | --- |
| Clientes | Listado, Detalle, Formulario, Eliminacion | Busqueda local, paginacion simulada, dialogo de confirmacion. |
| Ingredientes | Listado, Detalle, Formulario, Eliminacion | Campos numericos >= 0, indicador Activo, estados visibles. |
| Postres | Listado, Detalle, Formulario, Eliminacion | Gestion de recetas (agregar/editar/eliminar ingredientes). |
| Pedidos | Listado con filtros, Detalle (cambio de estado), Asistente de creacion en 3 pasos | Carrito simulado, totales y estados del pedido. |
| Eventos | Listado, Detalle, Formulario, Eliminacion | Permite asociar un pedido existente y manejar notas/fecha. |

La pantalla inicial muestra solo el boton **Ingresar**, que dirige al menu principal con accesos a cada recurso real del backend.

## Estructura
```
lib/
├─ core/                  # Tema y widgets reutilizables
├─ data/
│  ├─ models/             # Modelos simples para la UI mock
│  └─ repositories/
│     ├─ interfaces/      # Contratos por recurso
│     └─ memory/          # Repositorios en memoria con datos semilla
├─ providers/             # ChangeNotifier por recurso (estado cargando/exito/error + CRUD)
├─ presentation/
│  ├─ shell/              # WelcomePage y HomeMenuPage
│  ├─ clientes/           # list/detail/form en memoria
│  ├─ ingredientes/       # list/detail/form
│  ├─ postres/            # list/detail/form + formulario modal de receta
│  ├─ pedidos/            # list/detail/wizard
│  ├─ eventos/            # list/detail/form
│  └─ recetas/            # formulario para items de receta
└─ routes/                # AppRouter con rutas nombradas
```

## Estado en memoria
- Los archivos `lib/data/repositories/memory/*_repository_mem.dart` almacenan datos mock, generan IDs autoincrementales y simulan latencia con `Future.delayed`.
- Los providers (`lib/providers/*_provider.dart`) exponen propiedades `loading`, `error`, paginacion simulada y metodos `cargar`, `guardar`, `eliminar`, etc.
- Cada formulario valida campos basicos (requeridos, longitudes, valores > 0) y muestra mensajes en espanol para “Cargando...”, “Guardado” y “Error (simulado)”.

## Como reemplazar por llamadas HTTP
1. Implementa las interfaces de `lib/data/repositories/interfaces` usando tu cliente HTTP preferido.
2. Sustituye en `lib/main.dart` las clases `*_RepositoryMem` por las implementaciones HTTP.
3. Mantiene los providers y pantallas tal como estan; solo cambia la fuente de datos.

El frontend queda listo para integrarse al backend real sin rehacer la UI.
