import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/use_case/register_usecase.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_event.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase) : super(const RegisterState());

  void doEvent(RegisterEvent event) {
    switch (event) {
      case RegisterSubmitted():
        _register(event);
        break;
    }
  }

  Future<void> _register(RegisterSubmitted event) async {
    emit(
      state.copyWith(
        registerState: state.registerState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
    final request = RegisterRequest(
      fullName: '${event.firstName.trim()} ${event.lastName.trim()}'.trim(),
      email: event.email.trim(),
      phoneNumber: event.phoneNumber.trim(),
      gender: event.gender,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    final response = await _registerUseCase(request);

    switch (response) {
      case SuccessResponse<RegisterEntity>():
        emit(
          state.copyWith(
            registerState: state.registerState.copyWith(
              isLoading: false,
              data: (response as SuccessResponse).data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponse<RegisterEntity>():
        emit(
          state.copyWith(
            registerState: state.registerState.copyWith(
              isLoading: false,
              errorMessage: (response as ErrorResponse).errorMessage,
            ),
          ),
        );
    }
  }
}
