import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<List<PropertyModel>> getProperties();
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://tu-api-backend.com/api/v1'; // Reemplaza con la URL de tu servidor

  PropertyRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PropertyModel>> getProperties() async {
    final response = await client.get(
      Uri.parse('$baseUrl/properties'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PropertyModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener propiedades del servidor');
    }
  }
}