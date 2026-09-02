import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class DefaultAddressState extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  const DefaultAddressState({this.addressesState = const BaseState()});
  DefaultAddressState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
  }) {
    return DefaultAddressState(
      addressesState: addressesState ?? this.addressesState,
    );
  }

  @override
  List<Object?> get props => [addressesState];
}
