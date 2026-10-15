import '../../../../core/error/failure.dart';
import '../repositories/i_properties_repository.dart';

class DeletePropertyUsecase {
  final IPropertiesRepository _repository;

  const DeletePropertyUsecase(this._repository);

  Future<(bool, Failure?)> call({required String propertyId}) =>
      _repository.deleteProperty(propertyId: propertyId);
}
