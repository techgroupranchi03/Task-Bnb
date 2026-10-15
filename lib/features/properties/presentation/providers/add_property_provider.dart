import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../domain/entities/property_entity.dart';
import '../../domain/usecases/create_property_usecase.dart';
import '../../domain/usecases/update_property_usecase.dart';
import '../../domain/usecases/delete_property_usecase.dart';
import '../../data/repositories/properties_repository_impl.dart';
import '../../../../core/error/failure.dart';

// ── State ────────────────────────────────────────────────────────────────────
class AddPropertyState {
  final bool isLoading;
  final PropertyEntity? createdProperty;
  final Failure? failure;
  final bool isSuccess;

  const AddPropertyState({
    this.isLoading = false,
    this.createdProperty,
    this.failure,
    this.isSuccess = false,
  });

  AddPropertyState copyWith({
    bool? isLoading,
    PropertyEntity? createdProperty,
    Failure? failure,
    bool? isSuccess,
    bool clearFailure = false,
  }) =>
      AddPropertyState(
        isLoading: isLoading ?? this.isLoading,
        createdProperty: createdProperty ?? this.createdProperty,
        failure: clearFailure ? null : failure ?? this.failure,
        isSuccess: isSuccess ?? this.isSuccess,
      );

  void reset() {}
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class AddPropertyNotifier extends StateNotifier<AddPropertyState> {
  late final CreatePropertyUsecase _createUsecase;
  late final UpdatePropertyUsecase _updateUsecase;
  late final DeletePropertyUsecase _deleteUsecase;

  AddPropertyNotifier() : super(const AddPropertyState()) {
    final repo = PropertiesRepositoryImpl();
    _createUsecase = CreatePropertyUsecase(repo);
    _updateUsecase = UpdatePropertyUsecase(repo);
    _deleteUsecase = DeletePropertyUsecase(repo);
  }

  Future<void> createProperty({
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    state = state.copyWith(isLoading: true, clearFailure: true, isSuccess: false);
    final (property, failure) = await _createUsecase(
      name: name,
      address: address,
      googleMapLink: googleMapLink,
      image: image,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else {
      state = state.copyWith(
        isLoading: false,
        createdProperty: property,
        isSuccess: true,
      );
    }
  }

  Future<void> updateProperty({
    required String propertyId,
    required String name,
    required String address,
    required String googleMapLink,
    required File? image,
  }) async {
    state = state.copyWith(isLoading: true, clearFailure: true, isSuccess: false);
    final (property, failure) = await _updateUsecase(
      propertyId: propertyId,
      name: name,
      address: address,
      googleMapLink: googleMapLink,
      image: image,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else {
      state = state.copyWith(
        isLoading: false,
        createdProperty: property,
        isSuccess: true,
      );
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    final (success, failure) = await _deleteUsecase(propertyId: propertyId);
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
    } else {
      state = state.copyWith(
        isLoading: false,
        isSuccess: success,
      );
    }
  }

  void resetState() {
    state = const AddPropertyState();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final addPropertyProvider =
    StateNotifierProvider<AddPropertyNotifier, AddPropertyState>(
  (ref) => AddPropertyNotifier(),
);
