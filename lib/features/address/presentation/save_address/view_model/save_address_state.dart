import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class SaveAddressState extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  final String deletingId;
  final String actionError;

  const SaveAddressState({
    this.addressesState = const BaseState(),
    this.deletingId = '',
    this.actionError = '',
  });

  SaveAddressState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    String? deletingId,
    String? actionError,
  }) {
    return SaveAddressState(
      addressesState: addressesState ?? this.addressesState,
      deletingId: deletingId ?? this.deletingId,
      actionError: actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [addressesState, deletingId, actionError];
}
