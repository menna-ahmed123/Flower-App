import 'package:flower_app/core/base/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repos/auth_repository.dart';
import '../../pending_action.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthState.initial());

  final AuthRepository _authRepository;

  PendingAction? _pendingAction;

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

      case AuthAuthenticationRequired(:final pendingAction):
        _requireAuthentication(pendingAction);
        break;

      case AuthLoginSucceeded():
        await _handleAuthenticationSuccess();
        break;

      case AuthAuthenticationCancelled():
        _cancelAuthentication();
        break;
    }
  }

  void _cancelAuthentication() {
    _pendingAction = null;

    emit(
      state.copyWith(
        requiresAuthentication: false,
      ),
    );
  }

  void _continueAsGuest() {
    _pendingAction = null;

    emit(
      state.copyWith(
        authState: const BaseState(data: false),
        requiresAuthentication: false,
      ),
    );
  }

  Future<void> _checkAuth() async {
    final isAuthenticated = await _authRepository.isAuthenticated();

    emit(
      state.copyWith(
        authState: BaseState(data: isAuthenticated),
        requiresAuthentication: false,
      ),
    );
  }

  Future<void> _logout() async {
    await _authRepository.logout();

    _pendingAction = null;

    emit(
      state.copyWith(
        authState: const BaseState(data: false),
        requiresAuthentication: false,
      ),
    );
  }

  void _requireAuthentication(PendingAction? pendingAction) {
    _pendingAction = pendingAction;

    emit(
      state.copyWith(
        requiresAuthentication: false,
      ),
    );

    emit(
      state.copyWith(
        requiresAuthentication: true,
      ),
    );
  }
  Future<void> _handleAuthenticationSuccess() async {
    await _checkAuth();

    if (!state.isAuthenticated) {
      return;
    }

    emit(
      state.copyWith(
        requiresAuthentication: false,
      ),
    );

    await replayPendingAction();
  }

  Future<void> replayPendingAction() async {
    final action = _pendingAction;

    _pendingAction = null;

    if (action == null) {
      return;
    }

    await action();
  }

  void clearPendingAction() {
    _pendingAction = null;
  }

  @override
  Future<void> close() {
    _pendingAction = null;
    return super.close();
  }
}