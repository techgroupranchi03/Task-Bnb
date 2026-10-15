import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/property_model.dart';

class PropertiesRemoteDataSource {
  final DioClient _client;

  PropertiesRemoteDataSource({DioClient? client})
      : _client = client ?? DioClient.instance;

  Future<List<PropertyModel>> fetchProperties() async {
    final response = await _client.get(ApiEndpoints.clientProperties);

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final dataList = body['data'];
    if (dataList is! List) return [];

    return dataList
        .whereType<Map<String, dynamic>>()
        .map(PropertyModel.fromJson)
        .toList();
  }

  Future<PropertyModel> getPropertyById(String propertyId) async {
    final url = ApiEndpoints.clientPropertyById(propertyId);
    AppLogger.instance.info('PropertiesRemoteDataSource.getPropertyById', '📥 GET: $url');
    
    final response = await _client.get(url);

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    AppLogger.instance.info('PropertiesRemoteDataSource.getPropertyById', '✅ Response received');

    final data = body['data'] as Map<String, dynamic>? ?? {};
    return PropertyModel.fromJson(data);
  }

  Future<PropertyModel> createProperty({
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'address': address,
      'google_map_link': googleMapLink,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await _client.post(
      ApiEndpoints.clientProperties,
      data: formData,
    );

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final data = body['data'] as Map<String, dynamic>? ?? {};
    return PropertyModel.fromJson(data);
  }

  Future<PropertyModel> updateProperty({
    required String propertyId,
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'address': address,
      'google_map_link': googleMapLink,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final url = ApiEndpoints.clientPropertyById(propertyId);
    AppLogger.instance.info(
      'PropertiesRemoteDataSource.updateProperty',
      '🔄 PUT: $url | Has Image: ${formData.files.isNotEmpty}',
    );

    final response = await _client.put(
      url,
      data: formData,
    );

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final data = body['data'] as Map<String, dynamic>? ?? {};
    return PropertyModel.fromJson(data);
  }

  Future<void> deleteProperty(String propertyId) async {
    final url = ApiEndpoints.clientPropertyById(propertyId);
    AppLogger.instance.info('PropertiesRemoteDataSource.deleteProperty', '🗑️ DELETE: $url');
    await _client.delete(url);
  }
}

