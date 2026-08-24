import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._tokenStorage) : super(AuthState.initial());

  final TokenStorage _tokenStorage;

  Future<void> doEvent(AuthEvent event) async {
    switch (event) {
      case AuthCheckRequested():
        await _checkAuth();
        break;

      case AuthLogoutRequested():
        await _logout();
        break;

      case AuthGuestRequested():
        _continueAsGuest();
        break;
    }
  }

  void _continueAsGuest() {
    emit(state.copyWith(authState: const BaseState(data: false)));
  }

  Future<void> _checkAuth() async {
    final accessToken = await _tokenStorage.getAccessToken();

    emit(
      state.copyWith(
        authState: BaseState(
          data: accessToken != null && accessToken.isNotEmpty,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _tokenStorage.clearTokens();

    emit(state.copyWith(authState: const BaseState(data: false)));
  }
}
