import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/models/models.dart';
import 'postre_form_page.dart';
import 'package:pitty_app/providers/postres_provider.dart';
import '../recetas/receta_item_form.dart';

class PostreDetailPage extends StatefulWidget {
  const PostreDetailPage({super.key, required this.postreId});

  final int postreId;

  @override
  State<PostreDetailPage> createState() => _PostreDetailPageState();
}

class _PostreDetailPageState extends State<PostreDetailPage> {
  late Future<Postre> _postreFuture;
  late Future<Receta> _recetaFuture;

  @override
  void initState() {
    super.initState();
    final controller = context.read<PostresProvider>();
    _postreFuture = controller.obtener(widget.postreId);
    _recetaFuture = controller.obtenerReceta(widget.postreId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de postre')),
      body: FutureBuilder<Postre>(
        future: _postreFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('Cargando...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }
          final postre = snapshot.data;
          if (postre == null) {
            return const Center(child: Text('Postre no encontrado'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              final controller = context.read<PostresProvider>();
              setState(() {
                _postreFuture = controller.obtener(widget.postreId);
                _recetaFuture = controller.obtenerReceta(widget.postreId);
              });
              await Future.wait([_postreFuture, _recetaFuture]);
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              postre.nombre,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            StatusChip(
                              label: postre.activo ? 'Activo' : 'Inactivo',
                              color: postre.activo
                                  ? colorScheme.primaryContainer
                                  : colorScheme.errorContainer,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Precio: S/ ${postre.precio.toStringAsFixed(2)}'),
                        Text('Porciones: ${postre.porciones}'),
                        const SizedBox(height: 12),
                        Text('Creado el: ${formatDateTime(postre.createdAt)}'),
                        Text('Actualizado el: ${formatDateTime(postre.updatedAt)}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final result = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => PostreFormPage(postre: postre),
                                  ),
                                );
                                _handleResult(result);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar datos'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Eliminar postre'),
                                    content: Text(' Eliminar ${postre.nombre}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final success = await context.read<PostresProvider>().eliminar(postre.id);
                                  if (!mounted) return;
                                  Navigator.of(context).pop(success);
                                }
                              },
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Eliminar'),
                              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Receta',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                FutureBuilder<Receta>(
                  future: _recetaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: Text('Cargando...')),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Error al cargar la receta: ${snapshot.error}'),
                      );
                    }
                    final receta = snapshot.data;
                    final items = receta?.items ?? [];
                    if (items.isEmpty) {
                      return const EmptyState(message: 'Receta vacia. Agrega ingredientes.');
                    }
                    return Column(
                      children: [
                        ...items.map((item) => Card(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              child: ListTile(
                                title: Text(item.ingredienteNombre),
                                subtitle: Text(
                                  'Cantidad: ${item.cantidadPorPostre.toStringAsFixed(2)} ${item.unidad}\nMerma: ${item.mermaPct.toStringAsFixed(1)}%',
                                ),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      tooltip: 'Editar ingrediente',
                                      onPressed: () => _openRecetaForm(item.ingredienteId),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      tooltip: 'Eliminar',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text('Eliminar ingrediente'),
                                            content: Text(' Eliminar ${item.ingredienteNombre} de la receta?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text('Cancelar'),
                                              ),
                                              FilledButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await context
                                              .read<PostresProvider>()
                                              .eliminarItemReceta(postre.id, item.ingredienteId);
                                          setState(() {
                                            _recetaFuture = context
                                                .read<PostresProvider>()
                                                .obtenerReceta(postre.id);
                                          });
                                          _showSnackBar('Guardado');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _openRecetaForm(null),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar ingrediente a la receta'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openRecetaForm(int? ingredienteId) async {
    final controller = context.read<PostresProvider>();
    final receta = await controller.obtenerReceta(widget.postreId);
    final ingredienteActual = receta.items.firstWhere(
      (item) => item.ingredienteId == ingredienteId,
      orElse: () => RecetaItem(
        ingredienteId: -1,
        ingredienteNombre: '',
        unidad: '',
        cantidadPorPostre: 0,
        mermaPct: 0,
      ),
    );
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => RecetaItemForm(
        postreId: widget.postreId,
        controller: controller,
        ingredienteActual: ingredienteId != null && ingredienteActual.ingredienteId != -1
            ? ingredienteActual
            : null,
      ),
    );
    if (result != null) {
      setState(() {
        _recetaFuture = controller.obtenerReceta(widget.postreId);
      });
      _showSnackBar(result ? 'Guardado' : 'Error (simulado)');
    }
  }

  void _handleResult(bool? result) {
    if (result == null) return;
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    final isError = message.contains('Error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      ),
    );
  }
}
