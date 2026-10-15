import '../../../../core/error/failure.dart';
import 'dart:io';
import '../entities/property_entity.dart';
import '../repositories/i_properties_repository.dart';

class CreatePropertyUsecase {
  final IPropertiesRepository _repository;

  const CreatePropertyUsecase(this._repository);

  Future<(PropertyEntity?, Failure?)> call({
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) =>
      _repository.createProperty(
        name: name,
        address: address,
        googleMapLink: googleMapLink,
        image: image,
      );
}
