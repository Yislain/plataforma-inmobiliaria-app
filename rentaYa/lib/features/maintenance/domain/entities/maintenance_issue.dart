class MaintenanceIssue {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final String status;

  MaintenanceIssue({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.status = 'Pendiente',
  });
}