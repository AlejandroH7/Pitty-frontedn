// lib/presentation/pages/event_list_page.dart
import 'package:flutter/material.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Eventos'),
      ),
      body: const Center(
        child: Text('Listado de Eventos (UI placeholder)'),
      ),
    );
  }
}
