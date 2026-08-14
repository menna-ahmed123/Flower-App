export 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';

import 'package:equatable/equatable.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';

sealed class RegisterIntent extends Equatable {
  const RegisterIntent();
}

final class RegisterFieldChangedIntent extends RegisterIntent {
  const RegisterFieldChangedIntent(this.field, this.value);

  final RegisterField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

final class RegisterGenderChangedIntent extends RegisterIntent {
  const RegisterGenderChangedIntent(this.gender);

  final Gender gender;

  @override
  List<Object?> get props => [gender];
}

final class TogglePasswordVisibilityIntent extends RegisterIntent {
  const TogglePasswordVisibilityIntent({this.confirm = false});

  final bool confirm;

  @override
  List<Object?> get props => [confirm];
}

final class SubmitRegisterIntent extends RegisterIntent {
  const SubmitRegisterIntent();

  @override
  List<Object?> get props => [];
}

final class NavigateToLoginIntent extends RegisterIntent {
  const NavigateToLoginIntent();

  @override
  List<Object?> get props => [];
}

final class NavigateBackIntent extends RegisterIntent {
  const NavigateBackIntent();

  @override
  List<Object?> get props => [];
}

final class ClearRegisterEffectIntent extends RegisterIntent {
  const ClearRegisterEffectIntent();

  @override
  List<Object?> get props => [];
}
