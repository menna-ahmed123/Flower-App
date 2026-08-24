import 'package:flower_app/core/base/base_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(BaseState<bool>()) BaseState<bool> authState,
  }) = _AuthState;

  factory AuthState.initial() {
    return const AuthState();
  }
}
