import 'package:flutter/material.dart';
import 'router.dart'; // Importa la configuración de rutas

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plataforma Inmobiliaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Aquí conectamos la instancia de go_router
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
    );
  }
}