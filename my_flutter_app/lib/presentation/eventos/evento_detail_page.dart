import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/widgets/empty_state.dart';
import 'package:pitty_app/data/models/evento.dart';
import 'package:pitty_app/presentation/eventos/evento_form_page.dart';
import 'package:pitty_app/providers/eventos_provider.dart';

class EventoDetailPage extends StatefulWidget {
  const EventoDetailPage({super.key, required this.eventoId});

  final int eventoId;

  @override
  State<EventoDetailPage> createState() => _EventoDetailPageState();
}

class _EventoDetailPageState extends State<EventoDetailPage> {
  late Future<Evento> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<EventosProvider>().obtener(widget.eventoId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de evento')),
      body: FutureBuilder<Evento>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('Cargando...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }
          final evento = snapshot.data;
          if (evento == null) {
            return const EmptyState(title: 'Evento no encontrado');
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(evento.titulo, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      _InfoRow(label: 'Lugar', value: evento.lugar ?? 'Sin definir'),
                      _InfoRow(label: 'Fecha y hora', value: formatDateTime(evento.fechaHora)),
                      _InfoRow(
                        label: 'Pedido asociado',
                        value: evento.pedidoCliente != null
                            ? '${evento.pedidoCliente} (#${evento.pedidoId})'
                            : 'No asociado',
                      ),
                      const SizedBox(height: 12),
                      Text('Notas:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(evento.notas?.isNotEmpty == true ? evento.notas! : 'Sin notas'),
                      const SizedBox(height: 16),
                      Text('Creado el: ${formatDateTime(evento.createdAt)}'),
                      Text('Actualizado el: ${formatDateTime(evento.updatedAt)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => EventoFormPage(evento: evento),
                        ),
                      );
                      if (result != null) {
                        if (!mounted) return;
                        Navigator.of(context).pop(result);
                      }
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
                          title: const Text('Eliminar evento'),
                          content: const Text(' Deseas eliminar este evento?'),
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
                        final success = await context.read<EventosProvider>().eliminar(evento.id);
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
          );
        },
      ),
    );
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
        crossAxisAlignment: CrossAxisAlignment.start,
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


