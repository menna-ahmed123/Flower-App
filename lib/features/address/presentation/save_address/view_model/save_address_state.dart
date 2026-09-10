import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class SaveAddressState extends Equatable {
    final BaseState<AddressEntity> saveAddressState;
  final bool isSaved;

  const SaveAddressState({
   this.saveAddressState= const BaseState(),
   this.isSaved = false,
  });

  SaveAddressState copyWith({
    BaseState<AddressEntity>? saveAddressState,
    bool? isSaved,
  }) {
    return SaveAddressState(
      saveAddressState: saveAddressState ?? this.saveAddressState,
      isSaved: isSaved ?? this.isSaved,

    );
  }

  @override
  List<Object?> get props => [saveAddressState, isSaved];
}
