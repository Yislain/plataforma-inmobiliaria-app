import 'package:flutter/material.dart';
import 'router.dart'; // Importa la configuración de rutas
import 'package:app_inmobiliaria/config/feature_flags.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plataforma Inmobiliaria',
      
      // 1. Definimos el tema claro (estándar)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      
      // 2. Definimos el tema oscuro (Beta)
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, 
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // 3. AQUÍ USAMOS LA FEATURE FLAG:
      // Si está en 'true', fuerza el modo oscuro. Si está en 'false', usa el claro.
      themeMode: FeatureFlags.enableDarkModeBeta ? ThemeMode.dark : ThemeMode.light,
      
      // Conectamos la instancia de go_router
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
    );
  }
}