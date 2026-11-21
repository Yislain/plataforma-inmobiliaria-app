abstract class MaintenanceEvent {}

class LoadIssuesEvent extends MaintenanceEvent {}

class PickImageEvent extends MaintenanceEvent {}

class SubmitReportEvent extends MaintenanceEvent {
  final String title;
  final String description;
  final String urgency;
  final String? imagePath;

  SubmitReportEvent({
    required this.title,
    required this.description,
    this.urgency = 'Media',
    this.imagePath,
  });
}