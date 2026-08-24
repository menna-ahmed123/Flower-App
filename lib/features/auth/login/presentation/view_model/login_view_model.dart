import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/auth/presentation/view_model/auth_cubit.dart';
import '../../../../../core/auth/presentation/view_model/auth_event.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthCubit _authCubit;

  LoginViewModel(this._loginUseCase,
      this._authCubit,) : super(const LoginState());

  void doEvent(LoginEvent event) {
    switch (event) {
      case LoginSubmitted():
        _login(event.email, event.password);
        break;
    }
  }

  Future<void> _login(String email, String password) async {
    emit(
      state.copyWith(
        loginState: state.loginState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
    final request = LoginRequest(email: email, password: password);
    final response = await _loginUseCase(request);

    switch (response) {
      case SuccessResponse<AuthEntity>():
        await _authCubit.doEvent(
          const AuthEvent.authCheckRequested(),
        );

        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponse<AuthEntity>():
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}