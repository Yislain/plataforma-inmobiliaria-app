import 'dart:io';
import '../entities/property.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties();
  Future<void> addProperty({
    required String title,
    required String description,
    required double monthlyRent,
    required String location,
    required int bedrooms,
    required File imageFile,
  });
}