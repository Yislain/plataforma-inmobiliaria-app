import 'package:flutter_bloc/flutter_bloc.dart';
import 'property_event.dart';
import 'property_state.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository repository;

  PropertyBloc({required this.repository}) : super(PropertyInitial()) {
    on<LoadProperties>((event, emit) async {
      emit(PropertyLoading());
      try {
        final properties = await repository.getProperties();
        emit(PropertyLoaded(properties));
      } catch (e) {
        emit(PropertyError('Error al cargar propiedades: ${e.toString()}'));
      }
    });

    on<AddPropertyEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        await repository.addProperty(
          title: event.title,
          description: event.description,
          monthlyRent: event.monthlyRent,
          location: event.location,
          bedrooms: event.bedrooms,
          imageFile: event.imageFile,
        );
        emit(PropertyAddedSuccess());
        add(LoadProperties());
      } catch (e) {
        emit(PropertyError('Error al publicar propiedad: ${e.toString()}'));
      }
    });

    on<FilterProperties>((event, emit) async {
      emit(PropertyLoading());
      try {
        final properties = await repository.getProperties();
        final filtered = properties.where((p) {
          final matchesPrice = event.maxPrice == null || p.monthlyRent <= event.maxPrice!;
          final matchesLocation = event.location == null ||
              p.location.toLowerCase().contains(event.location!.toLowerCase());
          return matchesPrice && matchesLocation;
        }).toList();
        emit(PropertyLoaded(filtered));
      } catch (e) {
        emit(PropertyError('Error al filtrar propiedades: ${e.toString()}'));
      }
    });
  }
}