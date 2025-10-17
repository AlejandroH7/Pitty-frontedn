import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('App arranca', (WidgetTester tester) async {
    await tester.pumpWidget(const PittyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}
