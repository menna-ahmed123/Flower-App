import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';

class AddressState extends Equatable {
  final BaseState<LocationEntity> locationState;
  final BaseState<AddressEntity> addressState;
  final BaseState<List<GovernorateEntity>> governoratesState;
  final BaseState<List<CityEntity>> citiesState;
  final GovernorateEntity? selectedGovernorate;
  final CityEntity? selectedCity;

  const AddressState({
    this.locationState = const BaseState(),
    this.addressState = const BaseState(),
    this.governoratesState = const BaseState(),
    this.citiesState = const BaseState(),
    this.selectedGovernorate,
    this.selectedCity,
  });

  AddressState copyWith({
    BaseState<LocationEntity>? locationState,
    BaseState<AddressEntity>? addressState,
    BaseState<List<GovernorateEntity>>? governoratesState,
    BaseState<List<CityEntity>>? citiesState,
    GovernorateEntity? Function()? selectedGovernorate,
    CityEntity? Function()? selectedCity,
  }) {
    return AddressState(
      locationState: locationState ?? this.locationState,
      addressState: addressState ?? this.addressState,
      governoratesState: governoratesState ?? this.governoratesState,
      citiesState: citiesState ?? this.citiesState,
      selectedGovernorate: selectedGovernorate != null
          ? selectedGovernorate()
          : this.selectedGovernorate,
      selectedCity:
          selectedCity != null ? selectedCity() : this.selectedCity,
    );
  }

  @override
  List<Object?> get props => [
        locationState,
        addressState,
        governoratesState,
        citiesState,
        selectedGovernorate,
        selectedCity,
      ];
}
