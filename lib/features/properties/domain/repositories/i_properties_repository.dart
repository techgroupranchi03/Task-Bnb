import '../../../../core/error/failure.dart';
import 'dart:io';
import '../entities/property_entity.dart';

abstract class IPropertiesRepository {
  Future<(List<PropertyEntity>?, Failure?)> fetchProperties();

  Future<(PropertyEntity?, Failure?)> getPropertyById({required String propertyId});

  Future<(PropertyEntity?, Failure?)> createProperty({
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  });

  Future<(PropertyEntity?, Failure?)> updateProperty({
    required String propertyId,
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  });

  Future<(bool, Failure?)> deleteProperty({required String propertyId});
}
