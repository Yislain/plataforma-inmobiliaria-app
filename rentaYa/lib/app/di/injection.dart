import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/properties/data/repositories/firestore_property_repository.dart';
import '../../features/properties/domain/repositories/property_repository.dart';
import '../../features/properties/presentation/bloc/property_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Repositorios conectados a Firebase Auth y Cloud Firestore
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  getIt.registerLazySingleton<PropertyRepository>(
    () => FirestorePropertyRepository(),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<PropertyBloc>(
    () => PropertyBloc(repository: getIt<PropertyRepository>()),
  );
}