import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final CollectionReference _paymentsRef =
      FirebaseFirestore.instance.collection('payments');

  @override
  void initState() {
    super.initState();
    _seedInitialPaymentsIfEmpty();
  }

  Future<void> _seedInitialPaymentsIfEmpty() async {
    final snapshot = await _paymentsRef.limit(1).get();
    if (snapshot.docs.isEmpty) {
      await _paymentsRef.add({
        'concept': 'Renta Noviembre 2026',
        'property': 'Departamento Centro',
        'amount': 8500.0,
        'status': 'Pendiente',
        'method': 'Transferencia SPEI',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _paymentsRef.add({
        'concept': 'Renta Octubre 2026',
        'property': 'Departamento Centro',
        'amount': 8500.0,
        'status': 'Pagado',
        'method': 'Tarjeta Débito',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _markAsPaid(String docId, String concept, double amount) async {
    await _paymentsRef.doc(docId).update({'status': 'Pagado'});

    // Disparar notificación Push de confirmación (Sprint 9)
    await NotificationService().showLocalNotification(
      title: 'Pago Confirmado - RentaFácil',
      body: 'Se registró tu pago de \$$amount MXN ($concept).',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pago confirmado: $concept'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showNewPaymentDialog() {
    final conceptCtrl = TextEditingController(text: 'Renta Diciembre 2026');
    final amountCtrl = TextEditingController(text: '8500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar Nuevo Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: conceptCtrl,
              decoration: const InputDecoration(labelText: 'Concepto / Mes'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto (\$ MXN)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final concept = conceptCtrl.text.trim();
              final amount = double.tryParse(amountCtrl.text.trim()) ?? 8500.0;
              if (concept.isNotEmpty) {
                Navigator.pop(ctx);
                await _paymentsRef.add({
                  'concept': concept,
                  'property': 'Inmueble Arrendado',
                  'amount': amount,
                  'status': 'Pagado',
                  'method': 'Transferencia Digital',
                  'createdAt': FieldValue.serverTimestamp(),
                });

                await NotificationService().showLocalNotification(
                  title: 'Nuevo Pago Registrado',
                  body: '$concept por \$$amount MXN procesado correctamente.',
                );
              }
            },
            child: const Text('Pagar Ahora'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pagos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Probar Notificación Push',
            onPressed: () {
              NotificationService().showLocalNotification(
                title: 'Recordatorio de Renta',
                body: 'Tu próxima mensualidad vence en 3 días.',
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewPaymentDialog,
        icon: const Icon(Icons.add_card),
        label: const Text('Registrar Pago'),
        backgroundColor: const Color(0xFF4569EC),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _paymentsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay movimientos registrados.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final concept = data['concept'] ?? 'Mensualidad';
              final amount = (data['amount'] ?? 0).toDouble();
              final status = data['status'] ?? 'Pendiente';
              final isPaid = status == 'Pagado';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isPaid ? Colors.green.shade100 : Colors.orange.shade100,
                    child: Icon(
                      isPaid ? Icons.check_circle : Icons.pending_actions,
                      color: isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(
                    concept,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Monto: \$${amount.toStringAsFixed(2)} MXN\n${isPaid ? "Comprobante verificado" : "Toca para liquidar pago"}',
                  ),
                  isThreeLine: true,
                  trailing: Chip(
                    label: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: isPaid ? Colors.green : Colors.orange,
                    side: BorderSide.none,
                  ),
                  onTap: isPaid
                      ? null
                      : () => _markAsPaid(doc.id, concept, amount),
                ),
              );
            },
          );
        },
      ),
    );
  }
}