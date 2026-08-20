import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';

class RegisterState extends Equatable {
  @override
  List<Object?> get props => [registerState];

  final BaseState<RegisterEntity> registerState;

  const RegisterState({this.registerState = const BaseState()});

  RegisterState copyWith({BaseState<RegisterEntity>? registerState}) {
    return RegisterState(registerState: registerState ?? this.registerState);
  }
}
