import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RentRequestScreen extends StatelessWidget {
  const RentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Renta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Documentación requerida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Identificación Oficial (INE/Pasaporte)'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Comprobante de Ingresos'),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text('Subir'),
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Mensaje para el propietario (Opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4569EC),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Solicitud enviada para aprobación')),
                  );
                  if (context.canPop()) context.pop();
                },
                child: const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}