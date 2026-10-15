import '../../../../core/error/failure.dart';
import '../entities/property_entity.dart';
import '../repositories/i_properties_repository.dart';

class FetchPropertiesUsecase {
  final IPropertiesRepository _repository;

  const FetchPropertiesUsecase(this._repository);

  Future<(List<PropertyEntity>?, Failure?)> call() =>
      _repository.fetchProperties();
}
