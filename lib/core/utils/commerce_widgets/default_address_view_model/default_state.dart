import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class DefaultAddressState extends Equatable {
  final BaseState<List<AddressEntity>> defaultAddressesState;
  final String deletingId;
  final String actionError;
    final String settingDefaultId;
  const DefaultAddressState({
    this.deletingId = "",
    this.actionError = "",
    this.settingDefaultId = "",
    this.defaultAddressesState = const BaseState(),
  });

  DefaultAddressState copyWith({
    BaseState<List<AddressEntity>>? defaultAddressesState,
    String? deletingId,
    String? actionError,
    String? settingDefaultId,
  }) {
    return DefaultAddressState(
      deletingId: deletingId ?? this.deletingId,
      actionError: actionError ?? this.actionError,
      defaultAddressesState: defaultAddressesState ?? this.defaultAddressesState,
      settingDefaultId: settingDefaultId ?? this.settingDefaultId,
    );
  }

  @override
  List<Object?> get props => [defaultAddressesState, deletingId, actionError, settingDefaultId];
}
