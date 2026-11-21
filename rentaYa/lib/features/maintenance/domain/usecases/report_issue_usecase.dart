import '../entities/maintenance_issue.dart';
import '../repositories/maintenance_repository.dart';

class ReportIssueUseCase {
  final MaintenanceRepository repository;

  ReportIssueUseCase(this.repository);

  Future<void> call(MaintenanceIssue issue) async {
    // Aquí puedes agregar validaciones de negocio antes de enviar al repositorio
    return await repository.reportIssue(issue);
  }
}