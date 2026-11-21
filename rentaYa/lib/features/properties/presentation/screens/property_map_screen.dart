import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyMapScreen extends StatelessWidget {
  const PropertyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar en Mapa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo de mapa simulado
          Container(
            color: const Color(0xFFE0E0E0),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Integración de Google Maps / Mapbox',
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Buscador flotante
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar zona o código postal...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Tarjeta de propiedad flotante (Simulando un pin seleccionado)
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.blue[100],
                    child: const Icon(Icons.home, color: Colors.blue),
                  ),
                ),
                title: const Text('Departamento en Centro', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('\$12,000 / mes'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a detalles de propiedad...')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}