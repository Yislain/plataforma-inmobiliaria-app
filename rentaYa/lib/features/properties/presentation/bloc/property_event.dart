import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadProperties extends PropertyEvent {}

class FilterProperties extends PropertyEvent {
  final double? maxPrice;
  final String? location;

  const FilterProperties({this.maxPrice, this.location});

  @override
  List<Object?> get props => [maxPrice, location];
}

class AddPropertyEvent extends PropertyEvent {
  final String title;
  final String description;
  final double monthlyRent;
  final String location;
  final int bedrooms;
  final File imageFile;

  const AddPropertyEvent({
    required this.title,
    required this.description,
    required this.monthlyRent,
    required this.location,
    required this.bedrooms,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        monthlyRent,
        location,
        bedrooms,
        imageFile,
      ];
}