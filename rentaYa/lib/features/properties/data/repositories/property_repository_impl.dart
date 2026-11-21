import 'dart:io';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  @override
  Future<List<Property>> getProperties() async {
    return [];
  }

  @override
  Future<void> addProperty({
    required String title,
    required String description,
    required double monthlyRent,
    required String location,
    required int bedrooms,
    required File imageFile,
  }) async {
    // Implementación futura con Remote DataSource / API REST
  }
}