import 'package:flutter/material.dart';

import 'screens/lista_incidentes_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Central de Incidentes',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ListaIncidentesScreen(),
    ),
  );
}
