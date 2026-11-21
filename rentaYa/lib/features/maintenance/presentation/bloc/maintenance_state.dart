import '../../domain/entities/maintenance_issue.dart';

abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceImagePicked extends MaintenanceState {
  final String imagePath;
  MaintenanceImagePicked(this.imagePath);
}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceLoaded extends MaintenanceState {
  final List<MaintenanceIssue> issues;
  MaintenanceLoaded(this.issues);
}

class MaintenanceSuccess extends MaintenanceState {}

class MaintenanceError extends MaintenanceState {
  final String message;
  MaintenanceError(this.message);
}