import 'package:flutter/material.dart';
import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/widgets/status_chip.dart';
import 'package:pitty_app/data/models/ingrediente.dart';
import 'package:pitty_app/providers/ingredientes_provider.dart';
import 'package:pitty_app/routes/app_router.dart';
import 'package:provider/provider.dart';

class IngredienteDetailPage extends StatefulWidget {
  const IngredienteDetailPage({super.key, required this.ingredienteId});

  final int ingredienteId;

  @override
  State<IngredienteDetailPage> createState() => _IngredienteDetailPageState();
}

class _IngredienteDetailPageState extends State<IngredienteDetailPage> {
  late Future<Ingrediente> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<IngredientesProvider>().obtener(widget.ingredienteId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de ingrediente')),
      body: FutureBuilder<Ingrediente>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('Cargando...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }
          final ingrediente = snapshot.data;
          if (ingrediente == null) {
            return const Center(child: Text('Ingrediente no encontrado'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ingrediente.nombre,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        StatusChip(
                          label: ingrediente.activo ? 'Activo' : 'Inactivo',
                          color: ingrediente.activo
                              ? colorScheme.primaryContainer
                              : colorScheme.errorContainer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(label: 'Unidad', value: ingrediente.unidad),
                    _InfoRow(
                      label: 'Stock actual',
                      value: '${ingrediente.stockActual.toStringAsFixed(2)} ${ingrediente.unidad}',
                    ),
                    _InfoRow(
                      label: 'Stock minimo',
                      value: '${ingrediente.stockMinimo.toStringAsFixed(2)} ${ingrediente.unidad}',
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(label: 'Creado el', value: formatDateTime(ingrediente.createdAt)),
                    _InfoRow(label: 'Actualizado el', value: formatDateTime(ingrediente.updatedAt)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final result = await Navigator.of(context).pushNamed<bool>(
                              AppRoutes.ingredienteForm,
                              arguments: IngredienteFormArgs(ingrediente: ingrediente),
                            );
                            _handleResult(result);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Eliminar ingrediente'),
                                content: Text('Eliminar ${ingrediente.nombre}?'),
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
                              final success = await context.read<IngredientesProvider>().eliminar(ingrediente.id);
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
          );
        },
      ),
    );
  }

  void _handleResult(bool? result) {
    if (result == null) return;
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
