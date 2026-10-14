import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'router.dart';

void main() {
  // Aquí deberías inyectar tu implementación real del repositorio
  final authRepository = AuthRepositoryImpl(); 

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: const RealEstateApp(),
    ),
  );
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pasamos el Bloc al router para que escuche sus cambios
    final authBloc = context.read<AuthBloc>();
    final router = createRouter(authBloc);

    return MaterialApp.router(
      title: 'Plataforma Inmobiliaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router, 
      debugShowCheckedModeBanner: false,
    );
  }
}

// Dummy temporal para evitar errores hasta que conectes tu backend
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<dynamic> login(String email, String password) async {
    throw UnimplementedError();
  }
  
  @override
  Future<void> logout() async {}

  // CORRECCIÓN: Uso de parámetros nombrados requeridos para coincidir con la interfaz
  @override
  Future<dynamic> register({
    required String email,
    required String name,
    required String password,
    required String role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkAuthStatus() async {
    return false;
  }
}