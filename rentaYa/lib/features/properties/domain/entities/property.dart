import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String title;
  final String description;
  final double monthlyRent;
  final String location;
  final String imageUrl;
  final int bedrooms;
  final double latitude; 
  final double longitude;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.monthlyRent,
    required this.location,
    required this.imageUrl,
    required this.bedrooms,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [id, title, monthlyRent, location, bedrooms, latitude, longitude];
}