import '../../domain/entities/maintenance_issue.dart';
import '../../domain/repositories/maintenance_repository.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  // Patrón Singleton para mantener los datos en memoria entre pantallas durante la sesión
  static final MaintenanceRepositoryImpl _instance = MaintenanceRepositoryImpl._internal();
  factory MaintenanceRepositoryImpl() => _instance;
  MaintenanceRepositoryImpl._internal();

  // Base de datos simulada con datos iniciales
  final List<MaintenanceIssue> _mockDatabase = [
    MaintenanceIssue(
      id: '1',
      title: 'Fuga de agua en lavabo',
      description: 'Goteo constante en la llave del baño principal.',
      status: 'Pendiente',
    ),
    MaintenanceIssue(
      id: '2',
      title: 'Calentador no enciende',
      description: 'El piloto del boiler se apaga con el aire.',
      status: 'Resuelto',
    ),
  ];

  @override
  Future<List<MaintenanceIssue>> getIssues() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDatabase);
  }

  @override
  Future<void> reportIssue(MaintenanceIssue issue) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockDatabase.insert(0, issue); // Agrega el nuevo reporte al inicio de la lista
  }
}