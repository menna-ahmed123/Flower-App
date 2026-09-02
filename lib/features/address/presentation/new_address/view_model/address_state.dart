import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';

class AddressState extends Equatable {
  final BaseState<LocationEntity> locationState;
  final BaseState<AddressEntity> addressState;
  final bool isSaved;

  const AddressState({
    this.locationState = const BaseState(),
    this.addressState = const BaseState(),
    this.isSaved = false,
  });

  AddressState copyWith({
    BaseState<LocationEntity>? locationState,
    BaseState<AddressEntity>? addressState,
    bool? isSaved,
  }) {
    return AddressState(
      locationState: locationState ?? this.locationState,
      addressState: addressState ?? this.addressState,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        locationState,
        addressState,
        isSaved,
      ];
}