import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/usecases/fetch_properties_usecase.dart';
import '../../domain/usecases/delete_property_usecase.dart';
import '../../data/repositories/properties_repository_impl.dart';
import '../../../../core/error/failure.dart';

// ── State ────────────────────────────────────────────────────────────────────
class PropertiesState {
  final bool isLoading;
  final List<PropertyEntity> properties;
  final Failure? failure;

  const PropertiesState({
    this.isLoading = false,
    this.properties = const [],
    this.failure,
  });

  PropertiesState copyWith({
    bool? isLoading,
    List<PropertyEntity>? properties,
    Failure? failure,
    bool clearFailure = false,
  }) =>
      PropertiesState(
        isLoading: isLoading ?? this.isLoading,
        properties: properties ?? this.properties,
        failure: clearFailure ? null : failure ?? this.failure,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class PropertiesNotifier extends StateNotifier<PropertiesState> {
  late final FetchPropertiesUsecase _fetchUsecase;
  late final DeletePropertyUsecase _deleteUsecase;
  late final PropertiesRepositoryImpl _repo;

  PropertiesNotifier() : super(const PropertiesState()) {
    _repo = PropertiesRepositoryImpl();
    _fetchUsecase = FetchPropertiesUsecase(_repo);
    _deleteUsecase = DeletePropertyUsecase(_repo);
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final (properties, failure) = await _fetchUsecase();
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else {
      state = state.copyWith(isLoading: false, properties: properties ?? []);
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final (success, failure) = await _deleteUsecase(propertyId: propertyId);
    
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else if (success) {
      // Remove the deleted property from the list
      final updatedProperties = state.properties
          .where((p) => p.id != propertyId)
          .toList();
      state = state.copyWith(
        isLoading: false,
        properties: updatedProperties,
        clearFailure: true,
      );
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final propertiesProvider =
    StateNotifierProvider<PropertiesNotifier, PropertiesState>(
  (ref) => PropertiesNotifier(),
);
