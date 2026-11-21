import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Importa los archivos de tu BLoC (Ajusta la ruta si es necesario)
import '../bloc/maintenance_bloc.dart';
import '../bloc/maintenance_event.dart';
import '../bloc/maintenance_state.dart';

class MaintenanceReportScreen extends StatefulWidget {
  const MaintenanceReportScreen({super.key});

  @override
  State<MaintenanceReportScreen> createState() => _MaintenanceReportScreenState();
}

class _MaintenanceReportScreenState extends State<MaintenanceReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _urgency = 'Baja';
  String? _imagePath;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Falla'),
      ),
      // BlocConsumer escucha los estados del BLoC y reconstruye la UI
      body: BlocConsumer<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceImagePicked) {
            setState(() {
              _imagePath = state.imagePath;
            });
          } else if (state is MaintenanceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reporte enviado exitosamente')),
            );
            if (context.canPop()) context.pop(); // Regresa al listado
          } else if (state is MaintenanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is MaintenanceLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe el problema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Fuga de agua en el lavabo...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _urgency,
                  decoration: const InputDecoration(
                    labelText: 'Nivel de urgencia',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Baja', child: Text('Baja')),
                    DropdownMenuItem(value: 'Media', child: Text('Media')),
                    DropdownMenuItem(value: 'Alta', child: Text('Alta (Emergencia)')),
                  ],
                  onChanged: isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _urgency = value;
                            });
                          }
                        },
                ),
                const SizedBox(height: 16),
                
                // Muestra un indicador si la foto fue capturada exitosamente
                if (_imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Evidencia fotográfica adjunta')),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _imagePath = null;
                                  });
                                },
                        )
                      ],
                    ),
                  ),

                OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Dispara el evento para abrir la cámara
                          context.read<MaintenanceBloc>().add(PickImageEvent());
                        },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Adjuntar Evidencia Fotográfica'),
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
                    onPressed: isLoading
                        ? null // Deshabilita el botón mientras carga
                        : () {
                            if (_descriptionController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor, describe el problema')),
                              );
                              return;
                            }
                            
                            // Dispara el evento al BLoC con los datos del formulario
                            context.read<MaintenanceBloc>().add(
                                  SubmitReportEvent(
                                    title: 'Reporte - Urgencia $_urgency',
                                    description: _descriptionController.text,
                                    imagePath: _imagePath,
                                  ),
                                );
                          },
                    // Cambia el texto por un spinner animado si está enviando
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Enviar Reporte', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}