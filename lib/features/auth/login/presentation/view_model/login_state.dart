import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [loginState];

 final BaseState<AuthEntity> loginState;
  const LoginState({
    this.loginState = const BaseState(),
  });

  LoginState copyWith({
    BaseState<AuthEntity>? loginState,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
    );
  }
}