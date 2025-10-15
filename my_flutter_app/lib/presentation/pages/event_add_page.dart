// lib/presentation/pages/event_add_page.dart
import 'package:flutter/material.dart';

class EventAddPage extends StatelessWidget {
  const EventAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Evento'),
      ),
      body: const Center(
        child: Text('Pantalla de Agregar Evento (UI placeholder)'),
      ),
    );
  }
}
