import '../../domain/entities/maintenance_issue.dart';

class MaintenanceIssueModel extends MaintenanceIssue {
  final String urgency;
  final String date;

  MaintenanceIssueModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required this.urgency,
    required this.date,
  });

  // Factory para crear un modelo a partir de un JSON (ej. desde una API o Firebase)
  factory MaintenanceIssueModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceIssueModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'Pendiente',
      urgency: json['urgency'] as String? ?? 'Media',
      date: json['date'] as String? ?? '',
    );
  }

  // Método para convertir el modelo a JSON (ej. para enviar a una API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'urgency': urgency,
      'date': date,
    };
  }
}