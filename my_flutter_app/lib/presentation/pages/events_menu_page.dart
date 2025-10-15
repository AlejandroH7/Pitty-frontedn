// lib/presentation/pages/events_menu_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class EventsMenuPage extends StatelessWidget {
  const EventsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    'Eventos',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: CustomButton(
                        label: 'Agregar Evento',
                        filled: false,
                        trailingIcon: Icons.event_outlined,
                        onPressed: () {
                          Navigator.pushNamed(context, '/eventos/agregar');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: CustomButton(
                        label: 'Ver Eventos',
                        filled: false,
                        trailingIcon: Icons.expand_more,
                        onPressed: () {
                          Navigator.pushNamed(context, '/eventos/lista');
                        },
                      ),
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
