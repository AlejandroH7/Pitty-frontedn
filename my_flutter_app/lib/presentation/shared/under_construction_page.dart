import 'package:flutter/material.dart';

class UnderConstructionPage extends StatelessWidget {
  const UnderConstructionPage({
    super.key,
    required this.title,
    this.message = 'En construcción',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.build, size: 72),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Pronto agregaremos esta sección.'),
          ],
        ),
      ),
    );
  }
}
