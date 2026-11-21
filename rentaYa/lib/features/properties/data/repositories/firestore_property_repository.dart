import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../models/property_model.dart';

class FirestorePropertyRepository implements PropertyRepository {
  final FirebaseFirestore _firestore;

  FirestorePropertyRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _propertiesRef =>
      _firestore.collection('properties');

  @override
  Future<List<Property>> getProperties() async {
    var snapshot =
        await _propertiesRef.orderBy('createdAt', descending: true).get();

    if (snapshot.docs.isEmpty) {
      await _seedInitialProperties();
      snapshot =
          await _propertiesRef.orderBy('createdAt', descending: true).get();
    }

    return snapshot.docs
        .map((doc) => PropertyModel.fromFirestore(doc))
        .toList();
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
    await _propertiesRef.add({
      'title': title,
      'description': description,
      'monthlyRent': monthlyRent,
      'location': location,
      'bedrooms': bedrooms,
      'imageUrl':
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      'localImagePath': imageFile.path,
      'latitude': 20.3889,
      'longitude': -99.9961,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await NotificationService().showLocalNotification(
      title: 'Nueva Propiedad Publicada',
      body: '$title disponible en $location por \$$monthlyRent MXN/mes.',
    );
  }

  Future<void> _seedInitialProperties() async {
    await _propertiesRef.add({
      'title': 'Departamento Centro Histórico',
      'description':
          'Departamento moderno totalmente amueblado, excelente ubicación y servicios incluidos.',
      'monthlyRent': 8500.0,
      'location': 'Centro, Querétaro',
      'imageUrl':
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      'bedrooms': 2,
      'latitude': 20.5931,
      'longitude': -100.3928,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _propertiesRef.add({
      'title': 'Casa Residencial Juriquilla',
      'description':
          'Amplia residencia en privada con vigilancia 24/7, jardín y estacionamiento para 2 autos.',
      'monthlyRent': 14500.0,
      'location': 'Juriquilla, Querétaro',
      'imageUrl':
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      'bedrooms': 3,
      'latitude': 20.6975,
      'longitude': -100.4436,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}