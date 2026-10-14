import 'package:flutter/material.dart';

class LandlordDashboardScreen extends StatelessWidget {
  const LandlordDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RentaFácil - Propietario')),
      body: const Center(
        child: Text('Bienvenido, Arrendador.\nAquí gestionarás tus inmuebles.'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Mis Inmuebles'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}