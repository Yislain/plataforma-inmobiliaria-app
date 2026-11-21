import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/notification_service.dart';

class RentRequestScreen extends StatefulWidget {
  const RentRequestScreen({super.key});

  @override
  State<RentRequestScreen> createState() => _RentRequestScreenState();
}

class _RentRequestScreenState extends State<RentRequestScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _ineAttached = true;
  bool _incomeAttached = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_incomeAttached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adjunta tu comprobante de ingresos para continuar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('rent_requests').add({
        'tenantEmail': user?.email ?? 'inquilino@rentafacil.com',
        'tenantId': user?.uid ?? 'anonimo',
        'ineVerified': _ineAttached,
        'incomeVerified': _incomeAttached,
        'message': _messageController.text.trim(),
        'status': 'En Revisión',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await NotificationService().showLocalNotification(
        title: 'Solicitud de Renta Enviada',
        body: 'Tu documentación fue registrada y enviada al propietario.',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud guardada en Firestore y enviada para aprobación'),
            backgroundColor: Colors.green,
          ),
        );
        if (context.canPop()) context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar solicitud: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

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
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Identificación Oficial (INE/Pasaporte)'),
              trailing: Icon(
                _ineAttached ? Icons.check_circle : Icons.radio_button_unchecked,
                color: _ineAttached ? Colors.green : Colors.grey,
              ),
              onTap: () => setState(() => _ineAttached = !_ineAttached),
            ),
            ListTile(
              leading: const Icon(Icons.request_quote_outlined),
              title: const Text('Comprobante de Ingresos'),
              trailing: _incomeAttached
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : OutlinedButton(
                      onPressed: () {
                        setState(() => _incomeAttached = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comprobante adjuntado correctamente'),
                          ),
                        );
                      },
                      child: const Text('Subir'),
                    ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
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
                onPressed: _isSubmitting ? null : _submitRequest,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}