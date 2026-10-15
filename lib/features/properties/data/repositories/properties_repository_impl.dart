import 'package:dio/dio.dart';
import 'dart:io';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/i_properties_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../datasources/properties_remote_data_source.dart';

class PropertiesRepositoryImpl implements IPropertiesRepository {
  final PropertiesRemoteDataSource _remote;

  PropertiesRepositoryImpl({PropertiesRemoteDataSource? remote})
      : _remote = remote ?? PropertiesRemoteDataSource();

  @override
  Future<(List<PropertyEntity>?, Failure?)> fetchProperties() async {
    try {
      final models = await _remote.fetchProperties();
      return (models.map((m) => m.toEntity()).toList(), null);
    } catch (e, s) {
      return (
        null,
        _handleException(e, s, 'PropertiesRepository.fetchProperties')
      );
    }
  }

  @override
  Future<(PropertyEntity?, Failure?)> getPropertyById({required String propertyId}) async {
    try {
      final model = await _remote.getPropertyById(propertyId);
      return (model.toEntity(), null);
    } catch (e, s) {
      return (
        null,
        _handleException(e, s, 'PropertiesRepository.getPropertyById')
      );
    }
  }

  @override
  Future<(PropertyEntity?, Failure?)> createProperty({
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    try {
      final model = await _remote.createProperty(
        name: name,
        address: address,
        googleMapLink: googleMapLink,
        image: image,
      );
      return (model.toEntity(), null);
    } catch (e, s) {
      return (
        null,
        _handleException(e, s, 'PropertiesRepository.createProperty')
      );
    }
  }

  @override
  Future<(PropertyEntity?, Failure?)> updateProperty({
    required String propertyId,
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    try {
      final model = await _remote.updateProperty(
        propertyId: propertyId,
        name: name,
        address: address,
        googleMapLink: googleMapLink,
        image: image,
      );
      return (model.toEntity(), null);
    } catch (e, s) {
      return (
        null,
        _handleException(e, s, 'PropertiesRepository.updateProperty')
      );
    }
  }

  @override
  Future<(bool, Failure?)> deleteProperty({required String propertyId}) async {
    try {
      await _remote.deleteProperty(propertyId);
      return (true, null);
    } catch (e, s) {
      return (
        false,
        _handleException(e, s, 'PropertiesRepository.deleteProperty')
      );
    }
  }

  Failure _handleException(dynamic e, StackTrace s, String context) {
    AppLogger.instance.error(context, e, s);

    if (e is AppException) return _mapException(e);

    if (e is DioException) {
      if (e.error is AppException) return _mapException(e.error as AppException);

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ??
            data['error'] as String? ??
            data['msg'] as String?;
        if (message != null && message.isNotEmpty) {
          return UnknownFailure(message: message);
        }
      }
      if (e.message != null && e.message!.isNotEmpty) {
        return UnknownFailure(message: e.message!);
      }
    }

    return UnknownFailure(message: e.toString());
  }

  Failure _mapException(AppException e) {
    if (e is NetworkException) return NetworkFailure(message: e.message);
    if (e is TimeoutException) return TimeoutFailure(message: e.message);
    if (e is UnauthorizedException) return UnauthorizedFailure(message: e.message);
    if (e is ForbiddenException) return ForbiddenFailure(message: e.message);
    if (e is NotFoundException) return NotFoundFailure(message: e.message);
    if (e is ServerException) return ServerFailure(message: e.message);
    return UnknownFailure(message: e.message);
  }
}
