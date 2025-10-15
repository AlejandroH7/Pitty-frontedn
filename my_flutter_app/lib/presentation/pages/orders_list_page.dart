// lib/presentation/pages/orders_list_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, String>> pedidos = <Map<String, String>>[
      <String, String>{
        'cliente': 'Alejandro Herrera',
        'postre': 'Chunkys de limón',
        'cantidad': '7',
        'fecha': '07-10-25',
        'descripcion': '5ta calle, zona 2',
      },
      <String, String>{
        'cliente': 'Daniel Recinos',
        'postre': 'Cheesecake fresa',
        'cantidad': '2',
        'fecha': '05-10-25',
        'descripcion': 'Entrega en tienda',
      },
      <String, String>{
        'cliente': 'Juninior Gomes',
        'postre': 'Tres leches',
        'cantidad': '1',
        'fecha': '04-10-25',
        'descripcion': 'Con vela',
      },
      <String, String>{
        'cliente': 'Luis Castillo',
        'postre': 'Tiramisú',
        'cantidad': '3',
        'fecha': '06-10-25',
        'descripcion': 'Sin cacao arriba',
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    'Pedidos',
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pedidos.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == pedidos.length) {
                            return const ListTile(
                              dense: true,
                              leading: Icon(Icons.more_horiz),
                              title: Text('…(Resto de pedidos)'),
                              trailing: Icon(Icons.expand_more),
                            );
                          }

                          final Map<String, String> pedido = pedidos[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.radio_button_unchecked, size: 20),
                            title: Text(pedido['cliente'] ?? ''),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/pedidos/detalle',
                                arguments: <String, String>{
                                  'title': 'Pedidos',
                                  'cliente': pedido['cliente'] ?? '',
                                  'postre': pedido['postre'] ?? '',
                                  'cantidad': pedido['cantidad'] ?? '',
                                  'fecha': pedido['fecha'] ?? '',
                                  'anotacion': pedido['descripcion'] ?? '',
                                },
                              );
                            },
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
