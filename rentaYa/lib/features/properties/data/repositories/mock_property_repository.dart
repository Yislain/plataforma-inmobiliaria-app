import 'dart:io';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';

class MockPropertyRepository implements PropertyRepository {
  final List<Property> _properties = [
    const Property(
      id: '1',
      title: 'Departamento Centro Histórico',
      description: 'Hermoso departamento amueblado a 5 min de la plaza.',
      monthlyRent: 8500.0,
      location: 'Centro, Querétaro',
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=500',
      bedrooms: 2,
      latitude: 20.5881,
      longitude: -100.3899,
    ),
    const Property(
      id: '2',
      title: 'Casa Residencial Juriquilla',
      description: 'Amplia casa con jardín y alberca, seguridad 24/7.',
      monthlyRent: 15000.0,
      location: 'Juriquilla, Querétaro',
      imageUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=500',
      bedrooms: 3,
      latitude: 20.6811,
      longitude: -100.4430,
    ),
    const Property(
      id: '3',
      title: 'Estudio para Universitarios',
      description: 'Estudio compacto cerca del campus, servicios incluidos.',
      monthlyRent: 4500.0,
      location: 'San Juan del Río',
      imageUrl: 'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?q=80&w=500',
      bedrooms: 1,
      latitude: 20.3887,
      longitude: -99.9959,
    ),
  ];

  @override
  Future<List<Property>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_properties);
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
    await Future.delayed(const Duration(milliseconds: 800));

    final newProperty = Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      monthlyRent: monthlyRent,
      location: location,
      imageUrl: imageFile.path,
      bedrooms: bedrooms,
      latitude: 20.3888,
      longitude: -99.9959,
    );

    _properties.add(newProperty);
  }
}