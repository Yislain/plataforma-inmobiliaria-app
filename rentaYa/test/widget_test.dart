import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rentaya/features/maintenance/data/repositories/maintenance_repository_impl.dart';
import 'package:rentaya/features/maintenance/domain/entities/maintenance_issue.dart';
import 'package:rentaya/features/maintenance/domain/usecases/report_issue_usecase.dart';
import 'package:rentaya/features/maintenance/presentation/bloc/maintenance_bloc.dart';
import 'package:rentaya/features/maintenance/presentation/screens/maintenance_report_screen.dart';

void main() {
  group('Sprint 8 - Módulo de Mantenimiento e Incidencias', () {
    test('Caso de Uso: Reportar incidencia la registra en el repositorio', () async {
      final repository = MaintenanceRepositoryImpl();
      final useCase = ReportIssueUseCase(repository);

      final issue = MaintenanceIssue(
        id: '999',
        title: 'Fuga de agua en lavabo',
        description: 'Goteo constante en baño principal',
        status: 'Pendiente',
      );

      await useCase.call(issue);
      final issues = await repository.getIssues();

      expect(issues.any((item) => item.id == '999' && item.status == 'Pendiente'), isTrue);
    });

    testWidgets('UI: Renderiza formulario de reporte de incidencias correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => MaintenanceBloc(),
            child: const MaintenanceReportScreen(),
          ),
        ),
      );

      expect(find.text('Reportar Falla'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });
  });
}