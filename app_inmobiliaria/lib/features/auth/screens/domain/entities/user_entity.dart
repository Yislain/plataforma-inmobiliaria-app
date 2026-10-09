class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role; // 'Inquilino' o 'Propietario'
  final String token; // Token JWT para mantener la sesión

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });
}