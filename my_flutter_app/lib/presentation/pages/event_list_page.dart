import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = <Map<String, String>>[
      {
        'evento': 'Cumpleanos Alejandro',
        'cliente': 'Alejandro',
        'postre': 'Pastel tres leches',
        'cantidad': '2',
        'lugar': 'Aguacatan',
        'anotacion': 'Diseno inspirado en Spiderman',
        'fecha': '09-09-25',
      },
      {
        'evento': 'Fiestas Nacionales',
        'cliente': 'Comite Municipal',
        'postre': 'Cupcakes variados',
        'cantidad': '48',
        'lugar': 'Parque Central',
        'anotacion': 'Colores patrios',
        'fecha': '15-09-25',
      },
      {
        'evento': 'Colegio La Salle',
        'cliente': 'Direccion',
        'postre': 'Cheesecake de fresa',
        'cantidad': '3',
        'lugar': 'Salon de actos',
        'anotacion': 'Porciones marcadas',
        'fecha': '21-10-25',
      },
      {
        'evento': 'Aniversario Ana',
        'cliente': 'Ana',
        'postre': 'Tiramisu',
        'cantidad': '2',
        'lugar': 'Restaurante Orquidea',
        'anotacion': "Mensaje: 'Feliz aniversario'",
        'fecha': '02-11-25',
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 24),
                Text(
                  'Eventos',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 8,
                        thickness: 1,
                        indent: 52,
                        endIndent: 8,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          leading: Icon(
                            Icons.radio_button_unchecked,
                            color: theme.colorScheme.primary,
                          ),
                          title: Text(event['evento'] ?? '-'),
                          subtitle: Text('Cliente: ${event['cliente'] ?? '-'}'),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/eventos/detalle',
                            arguments: event,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Volver',
                    filled: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
