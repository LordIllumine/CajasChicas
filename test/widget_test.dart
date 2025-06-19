import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cajas_chicas/main.dart'; // Asegúrate de que el nombre coincida con tu proyecto

void main() {
  testWidgets('Login screen renders properly', (WidgetTester tester) async {
    // Construye la app principal
    await tester.pumpWidget(const MyApp());

    // Verifica que los elementos básicos estén presentes
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Usuario y contraseña
    expect(find.text('INGRESAR'), findsOneWidget);
  });
}
