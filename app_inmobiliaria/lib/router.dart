import 'features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importación de la pantalla de Login real
import 'features/auth/screens/login_screen.dart';

/// 1. Estado de autenticación simulado
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  AuthNotifier() {
    _checkToken();
  }

  // Simula la lectura del JWT al abrir la app
  Future _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));
    _status = AuthStatus.unauthenticated; 
    notifyListeners();
  }

  void login() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

// Instancia global del estado de autenticación
final authNotifier = AuthNotifier();

/// 2. Configuración del Router
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier, 
  redirect: (context, state) {
    final status = authNotifier.status;
    final isGoingToLogin = state.uri.toString() == '/login';
    final isOnSplash = state.uri.toString() == '/';

    // Escenario 1: App iniciando, validando token
    if (status == AuthStatus.unknown) {
      return isOnSplash ? null : '/';
    }

    // Escenario 2: Usuario sin sesión activa o token expirado
    if (status == AuthStatus.unauthenticated) {
      return isGoingToLogin ? null : '/login';
    }

    // Escenario 3: Usuario autenticado intenta entrar a Splash o Login
    if (status == AuthStatus.authenticated) {
      if (isGoingToLogin || isOnSplash) return '/home';
    }

    // Escenario 4: Ruta permitida
    return null; 
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(), // Conectado a tu archivo real
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

/// 3. Pantallas Temporales 
/// (Se eliminarán cuando creemos sus archivos en la carpeta features)

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }
}

