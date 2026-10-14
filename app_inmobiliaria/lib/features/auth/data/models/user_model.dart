import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String name,
    required String email,
    required UserRole role,
  }) : super(id: id, name: name, email: email, role: role);

  // Toma un JSON (Map) y lo convierte en un UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: _mapStringToRole(json['role']?.toString()),
    );
  }

  // Convierte el UserModel de vuelta a JSON (útil para guardar en caché local)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
    };
  }

  // Método auxiliar para mapear el texto del backend al Enum de Dart
  static UserRole _mapStringToRole(String? roleString) {
    switch (roleString?.toLowerCase()) {
      case 'arrendador':
      case 'propietario':
        return UserRole.arrendador;
      case 'admin':
      case 'administrador':
        return UserRole.admin;
      case 'inquilino':
      default:
        return UserRole.inquilino; // Rol por defecto por seguridad
    }
  }
}