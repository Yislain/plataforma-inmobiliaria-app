import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/maintenance_repository_impl.dart';
import '../../domain/entities/maintenance_issue.dart';
import '../../domain/usecases/report_issue_usecase.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final ImagePicker _picker = ImagePicker();
  final MaintenanceRepositoryImpl _repository;
  final ReportIssueUseCase _reportIssueUseCase;

  MaintenanceBloc({
    MaintenanceRepositoryImpl? repository,
    ReportIssueUseCase? reportIssueUseCase,
  })  : _repository = repository ?? MaintenanceRepositoryImpl(),
        _reportIssueUseCase = reportIssueUseCase ??
            ReportIssueUseCase(repository ?? MaintenanceRepositoryImpl()),
        super(MaintenanceInitial()) {
    // Cargar el listado de incidencias
    on<LoadIssuesEvent>((event, emit) async {
      emit(MaintenanceLoading());
      try {
        final issues = await _repository.getIssues();
        emit(MaintenanceLoaded(issues));
      } catch (e) {
        emit(MaintenanceError("Error al cargar el listado de incidencias"));
      }
    });

    // Manejar la selección de imagen
    on<PickImageEvent>((event, emit) async {
      try {
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          emit(MaintenanceImagePicked(image.path));
        }
      } catch (e) {
        emit(MaintenanceError("Error al capturar la imagen"));
      }
    });

    // Manejar el envío del reporte ejecutando el Caso de Uso hacia el Repositorio
    on<SubmitReportEvent>((event, emit) async {
      emit(MaintenanceLoading());
      try {
        final newIssue = MaintenanceIssue(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.description.isNotEmpty
              ? event.description
              : 'Reporte de incidencia',
          description: event.imagePath != null
              ? 'Con evidencia fotográfica adjunta'
              : 'Reporte registrado sin fotografía',
          status: 'Pendiente',
        );

        await _reportIssueUseCase.call(newIssue);

        emit(MaintenanceSuccess());
      } catch (e) {
        emit(MaintenanceError("Error al enviar el reporte"));
      }
    });
  }
}