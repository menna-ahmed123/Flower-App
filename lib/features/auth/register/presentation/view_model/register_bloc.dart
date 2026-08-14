import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/mappers/register_state_mapper.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class RegisterBloc extends Bloc<RegisterIntent, RegisterState> {
  RegisterBloc(this._registerUseCase, this._validator)
    : super(const RegisterState()) {
    on<RegisterFieldChangedIntent>(_onFieldChanged);
    on<RegisterGenderChangedIntent>(_onGenderChanged);
    on<TogglePasswordVisibilityIntent>(_onTogglePasswordVisibility);
    on<SubmitRegisterIntent>(_onSubmitRegister);
    on<NavigateToLoginIntent>(_onNavigateToLogin);
    on<NavigateBackIntent>(_onNavigateBack);
    on<ClearRegisterEffectIntent>(_onClearEffect);
  }

  final RegisterUseCase _registerUseCase;
  final RegisterFormValidator _validator;

  void _onFieldChanged(
    RegisterFieldChangedIntent intent,
    Emitter<RegisterState> emit,
  ) {
    if (state.isLoading) return;
    final next = _copyField(intent.field, intent.value);
    final partial = _validator.validateChangedField(
      intent.field,
      RegisterStateMapper.toFormInput(next),
    );
    emit(
      next.copyWith(
        fieldErrors: state.fieldErrors.applyChangedField(intent.field, partial),
      ),
    );
  }

  RegisterState _copyField(RegisterField field, String value) {
    return switch (field) {
      RegisterField.firstName => state.copyWith(firstName: value),
      RegisterField.lastName => state.copyWith(lastName: value),
      RegisterField.email => state.copyWith(email: value),
      RegisterField.password => state.copyWith(password: value),
      RegisterField.confirmPassword => state.copyWith(confirmPassword: value),
      RegisterField.phoneNumber => state.copyWith(phoneNumber: value),
    };
  }

  void _onGenderChanged(
    RegisterGenderChangedIntent intent,
    Emitter<RegisterState> emit,
  ) {
    if (state.isLoading) return;
    emit(state.copyWith(gender: intent.gender));
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityIntent intent,
    Emitter<RegisterState> emit,
  ) {
    if (state.isLoading) return;
    if (intent.confirm) {
      emit(
        state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword),
      );
      return;
    }
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onNavigateToLogin(
    NavigateToLoginIntent intent,
    Emitter<RegisterState> emit,
  ) {
    if (state.isLoading) return;
    emit(state.copyWith(effect: const NavigateToLoginEffect()));
  }

  void _onNavigateBack(NavigateBackIntent intent, Emitter<RegisterState> emit) {
    if (state.isLoading) return;
    emit(state.copyWith(effect: const NavigateBackEffect()));
  }

  void _onClearEffect(
    ClearRegisterEffectIntent intent,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(clearEffect: true));
  }

  Future<void> _onSubmitRegister(
    SubmitRegisterIntent intent,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isLoading) return;

    final errors = _validator.validate(RegisterStateMapper.toFormInput(state));
    if (errors.hasErrors) {
      emit(state.copyWith(fieldErrors: errors));
      return;
    }

    emit(state.copyWith(isLoading: true, clearData: true));
    final result = await _registerUseCase(RegisterStateMapper.toRequest(state));
    emit(_reduceResult(result));
  }

  RegisterState _reduceResult(BaseResponse<RegisterResult> result) {
    return switch (result) {
      SuccessResponse(:final data) => state.copyWith(
        isLoading: false,
        fieldErrors: RegisterFieldErrors.empty,
        data: data,
        effect: NavigateToLoginEffect(successMessage: successMessage(data)),
      ),
      ErrorResponse(:final appError) => state.copyWith(
        isLoading: false,
        clearData: true,
        effect: ShowErrorMessageEffect(appError.message),
      ),
    };
  }

  String successMessage(RegisterResult data) {
    if (data.message.isNotEmpty) return data.message;
    return AppString.signupSuccess;
  }
}
