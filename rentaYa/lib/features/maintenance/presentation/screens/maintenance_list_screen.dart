import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/notification_service.dart';
import '../bloc/maintenance_bloc.dart';
import '../bloc/maintenance_event.dart';
import '../bloc/maintenance_state.dart';

class MaintenanceListScreen extends StatelessWidget {
  const MaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MaintenanceBloc()..add(LoadIssuesEvent()),
      child: const _MaintenanceListView(),
    );
  }
}

class _MaintenanceListView extends StatefulWidget {
  const _MaintenanceListView();

  @override
  State<_MaintenanceListView> createState() => _MaintenanceListViewState();
}

class _MaintenanceListViewState extends State<_MaintenanceListView> {
  final Set<String> _inProgressTitles = {};

  Future<void> _notifyStatusChange(String title) async {
    setState(() {
      _inProgressTitles.add(title);
    });

    await NotificationService().showLocalNotification(
      title: 'Actualización de Mantenimiento',
      body: 'Tu reporte "$title" cambió de estado a: En Proceso.',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado y notificación enviada: $title'),
          backgroundColor: Colors.blue.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reportes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/maintenance-report');
          if (context.mounted) {
            context.read<MaintenanceBloc>().add(LoadIssuesEvent());
            await NotificationService().showLocalNotification(
              title: 'Reporte de Mantenimiento Recibido',
              body: 'Tu incidencia fue registrada y notificada al propietario.',
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reporte'),
        backgroundColor: const Color(0xFF4569EC),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
        builder: (context, state) {
          if (state is MaintenanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MaintenanceError) {
            return Center(child: Text(state.message));
          } else if (state is MaintenanceLoaded) {
            final issues = state.issues;
            if (issues.isEmpty) {
              return const Center(
                child: Text('No tienes reportes de mantenimiento.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];
                final isUpdated = _inProgressTitles.contains(issue.title);
                final currentStatus = isUpdated ? 'En Proceso' : issue.status;
                final isPending = currentStatus == 'Pendiente';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPending
                          ? Colors.orange.shade100
                          : Colors.blue.shade100,
                      child: Icon(
                        isPending ? Icons.build_circle : Icons.engineering,
                        color: isPending ? Colors.orange : Colors.blue,
                      ),
                    ),
                    title: Text(
                      issue.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${issue.description}\n${isPending ? "Toca para simular cambio de estatus" : "Técnico asignado"}',
                    ),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(
                        currentStatus,
                        style: TextStyle(
                          color: isPending
                              ? Colors.orange.shade900
                              : Colors.blue.shade900,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: isPending
                          ? Colors.orange.shade50
                          : Colors.blue.shade50,
                      side: BorderSide.none,
                    ),
                    onTap: isPending
                        ? () => _notifyStatusChange(issue.title)
                        : null,
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}