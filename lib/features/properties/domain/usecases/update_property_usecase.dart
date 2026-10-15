import '../../../../core/error/failure.dart';
import 'dart:io';
import '../entities/property_entity.dart';
import '../repositories/i_properties_repository.dart';

class UpdatePropertyUsecase {
  final IPropertiesRepository _repository;

  const UpdatePropertyUsecase(this._repository);

  Future<(PropertyEntity?, Failure?)> call({
    required String propertyId,
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) =>
      _repository.updateProperty(
        propertyId: propertyId,
        name: name,
        address: address,
        googleMapLink: googleMapLink,
        image: image,
      );
}
