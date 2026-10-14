// lib/features/auth/domain/entities/user_entity.dart

enum UserRole {
  inquilino,
  arrendador,
  admin, // Opcional, según tu documento
}

class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}