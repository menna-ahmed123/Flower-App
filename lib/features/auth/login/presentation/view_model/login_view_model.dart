import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/use_case/get_fcm_token_usecase.dart';
import 'package:flower_app/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flower_app/features/notification/domain/use_cases/get_device_id_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(
    this._loginUseCase,
    this._getDeviceIdUseCase,
    this._getFcmTokenUseCase,
  ) : super(const LoginState());

  final LoginUseCase _loginUseCase;
  final GetDeviceIdUseCase _getDeviceIdUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;

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

    try {
      final deviceId = await _getDeviceIdUseCase();
      final fcmToken = await _getFcmTokenUseCase();

      final request = LoginRequest(
        email: email,
        password: password,
        deviceId: deviceId,
        fcmToken: fcmToken ?? '',
      );

      final response = await _loginUseCase(request);

      switch (response) {
        case SuccessResponse<AuthEntity>():
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
          break;
      }
    } catch (error) {
      emit(
        state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }
}
