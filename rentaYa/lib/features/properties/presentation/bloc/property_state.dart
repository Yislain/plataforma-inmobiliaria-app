import 'package:equatable/equatable.dart';
import '../../domain/entities/property.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();
  
  @override
  List<Object?> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final List<Property> properties;

  const PropertyLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class PropertyAddedSuccess extends PropertyState {}

class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);

  @override
  List<Object?> get props => [message];
}