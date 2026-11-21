import '../entities/maintenance_issue.dart';

abstract class MaintenanceRepository {
  Future<List<MaintenanceIssue>> getIssues();
  Future<void> reportIssue(MaintenanceIssue issue);
}