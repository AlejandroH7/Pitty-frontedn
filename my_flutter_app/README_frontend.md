# Pitty Frontend (Flutter)

Frontend multiplataforma construido con Flutter 3 y Provider para gestionar la UI de la pastelería **Pitty**. Esta versión funciona completamente en memoria (sin llamadas HTTP) y sustituye la interfaz previa.

## Requisitos

- Flutter 3.x con soporte para null-safety.
- Dart SDK compatible (>=3.0.0 <4.0.0).

## Puesta en marcha

```bash
flutter pub get
flutter run
```

> **Nota:** si estás sin conexión durante `flutter pub get`, vuelve a ejecutar el comando cuando tengas acceso a la red para descargar la dependencia `provider`.

## Estructura principal

- `lib/main.dart`: punto de entrada, registro de `Provider`s y `ThemeData`.
- `lib/routes/app_router.dart`: rutas nombradas y navegación centralizada.
- `lib/core/`: temas y widgets reutilizables.
- `lib/data/`: modelos y repositorios en memoria.
- `lib/providers/`: `ChangeNotifier`s que gestionan el estado de cada módulo.
- `lib/presentation/`: pantallas y componentes específicos por flujo.

## Pantallas disponibles

| Pantalla | Descripción |
| --- | --- |
| **Bienvenida** | Pantalla inicial con botón **Ingresar** que prepara datos y lleva al menú principal. |
| **Menú principal** | Grid con accesos a Clientes, Postres, Categorías, Pedidos, Inventario (placeholder), Reportes (placeholder) y Configuración (placeholder). |
| **Clientes** | Listado con búsqueda y paginación simulada, detalle, formulario (crear/editar) y eliminación con confirmación. |
| **Postres** | Listado con búsqueda/paginación, detalle con categoría vinculada, formulario con validaciones de precio/categoría e imagen opcional, eliminación con confirmación. |
| **Categorías** | Listado con búsqueda simple, paginación simulada en cliente, formulario básico y eliminación con confirmación. |
| **Pedidos** | Flujo de tres pasos: selección de postres, carrito (edición de cantidades) y confirmación con total y notas opcionales. Mensaje “Pedido creado (simulado)” tras confirmar. |
| **Placeholders** | Inventario, Reportes y Configuración muestran pantalla “En construcción”. |

Estados visibles en cada módulo: “Cargando…”, “Guardando…” y mensajes de error simulados mediante `SnackBar` y etiquetas en pantalla.

## Repositorios en memoria

Los repositorios (`lib/data/repositories/*_mem.dart`) mantienen listas locales con IDs autoincrementales y simulan delays asíncronos. Se diseñaron como interfaz + implementación para permitir el reemplazo por servicios REST en el futuro:

1. **Clientes/Postres/Categorías** usan reglas simples de validación y pueden lanzar `Exception('Error simulado …')` cuando se intenta guardar con nombres que contengan la palabra “error”.
2. **Pedidos** guarda un historial local y expone `confirmarPedido`, que limpia el carrito tras usar `CarritoProvider`.

Para conectar con el backend real solo hay que implementar las interfaces (`*_repository.dart`) utilizando HTTP y reemplazar las versiones `*_mem.dart` en `main.dart`.

## Providers

- `ClientesProvider`, `PostresProvider`, `CategoriasProvider`: controlan listas, búsqueda, paginación y operaciones CRUD simuladas.
- `CarritoProvider`: maneja el carrito de pedidos, cálculo de totales y confirmación simulada.

Cada formulario bloquea el botón principal mientras guarda y despliega mensajes de éxito/error mediante `SnackBar`.

## Personalización futura

- Sustituye los repositorios en memoria por implementaciones HTTP apuntando al backend.
- Conecta los formularios con DTOs reales utilizando los mismos providers.
- Expande los placeholders (Inventario, Reportes, Configuración) reutilizando la infraestructura creada.

¡Lista para iterar sobre la experiencia final con datos reales! 
