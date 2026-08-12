import 'package:bloc/bloc.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const LoginState());
  void doEvent(LoginEvent event) {
    switch (event) {
      case Login():
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
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              data: (response as SuccessResponse).data,
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
              errorMessage: (response as ErrorResponse).errorMessage,
            ),
          ),
        );
    }
  }
}
