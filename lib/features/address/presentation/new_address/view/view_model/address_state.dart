import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';

class AddressState extends Equatable {
  final BaseState<LocationEntity> locationState;
  final BaseState<AddressEntity> addressState;

  const AddressState({
    this.locationState = const BaseState(),
    this.addressState = const BaseState(),
  });

  @override
  List<Object?> get props => [locationState, addressState];

  AddressState copyWith({
    BaseState<LocationEntity>? locationState,
    BaseState<AddressEntity>? addressState,
  }) {
    return AddressState(
      locationState: locationState ?? this.locationState,
      addressState: addressState ?? this.addressState,
    );
  }
}
