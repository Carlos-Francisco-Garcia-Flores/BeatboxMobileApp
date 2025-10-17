import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/app.dart'; // importa tu app real

void main() {
  testWidgets('La app muestra la pantalla de bienvenida', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const MyApp());

    // Verificar que aparece el texto de Bienvenida
    expect(find.text('¡Bienvenido!'), findsOneWidget);
  });
}
