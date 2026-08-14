import 'package:equatable/equatable.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.phoneNumber = '',
    this.gender = Gender.female,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isLoading = false,
    this.fieldErrors = RegisterFieldErrors.empty,
    this.data,
    this.effect,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final Gender gender;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final RegisterFieldErrors fieldErrors;
  final RegisterResult? data;
  final RegisterEffect? effect;

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    Gender? gender,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isLoading,
    RegisterFieldErrors? fieldErrors,
    RegisterResult? data,
    RegisterEffect? effect,
    bool clearData = false,
    bool clearEffect = false,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      isLoading: isLoading ?? this.isLoading,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      data: clearData ? null : (data ?? this.data),
      effect: clearEffect ? null : (effect ?? this.effect),
    );
  }

  RegisterRequest toRequest() {
    return RegisterRequest(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      password: password,
      phoneNumber: phoneNumber.trim(),
      gender: gender,
    );
  }

  RegisterFormInput toFormInput() {
    return RegisterFormInput(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    confirmPassword,
    phoneNumber,
    gender,
    obscurePassword,
    obscureConfirmPassword,
    isLoading,
    fieldErrors,
    data,
    effect,
  ];
}
