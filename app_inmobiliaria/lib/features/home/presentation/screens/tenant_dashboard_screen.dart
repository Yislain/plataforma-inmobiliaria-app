// lib/features/home/screens/tenant_dashboard_screen.dart
import 'package:flutter/material.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key}); // <-- Corrección aplicada aquí

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RentaFácil - Inquilino')),
      body: const Center(
        child: Text('Bienvenido, Inquilino.\nAquí verás el catálogo de propiedades.'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Mis Contratos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}