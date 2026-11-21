import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/property.dart';

class PropertyModel extends Property {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.monthlyRent,
    required super.location,
    required super.bedrooms,
    required super.imageUrl,
    required super.latitude,
    required super.longitude,
  });

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return PropertyModel(
      id: doc.id,
      title: data['title'] ?? 'Inmueble en Renta',
      description: data['description'] ?? '',
      monthlyRent:
          ((data['monthlyRent'] ?? data['monthly_rent']) as num?)?.toDouble() ??
              0.0,
      location: data['location'] ?? 'Querétaro',
      bedrooms: (data['bedrooms'] as num?)?.toInt() ?? 1,
      imageUrl: data['imageUrl'] ??
          data['image_url'] ??
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 20.3889,
      longitude: (data['longitude'] as num?)?.toDouble() ?? -99.9961,
    );
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      monthlyRent: (json['monthly_rent'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] ?? '',
      bedrooms: json['bedrooms'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'monthly_rent': monthlyRent,
      'location': location,
      'bedrooms': bedrooms,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}