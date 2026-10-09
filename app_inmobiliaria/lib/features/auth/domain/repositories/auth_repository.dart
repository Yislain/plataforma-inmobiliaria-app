import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Inicia sesión con correo y contraseña, y retorna el usuario con su token.
  Future login(String email, String password);

  /// Registra un nuevo usuario en la plataforma.
  Future register({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  /// Cierra la sesión activa borrando los tokens locales.
  Future logout();

  /// Verifica si hay un token válido guardado en el dispositivo.
  Future checkAuthStatus();
}