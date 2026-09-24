import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_event.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_sessions_use_case.dart';
import '../../domain/usecases/revoke_session_use_case.dart';

@injectable
class SessionsViewModel extends Cubit<SessionsState> {
  SessionsViewModel(this._getSessionsUseCase, this._revokeSessionUseCase)
      : super(const SessionsState());

  final GetSessionsUseCase _getSessionsUseCase;
  final RevokeSessionUseCase _revokeSessionUseCase;

  Future<void> onEvent(SessionsEvent event) async {
    switch (event) {
      case LoadSessions():
        await _loadSessions();

      case RevokeSession(:final sessionId):
        await _revokeSession(sessionId);
    }
  }

  Future<void> _loadSessions() async {
    emit(
      state.copyWith(
        sessionsState: state.sessionsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _getSessionsUseCase();

    switch (response) {
      case SuccessResponse<List<SessionEntity>>():
        emit(
          state.copyWith(
            sessionsState: state.sessionsState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<List<SessionEntity>>():
        emit(
          state.copyWith(
            sessionsState: state.sessionsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _revokeSession(String sessionId) async {
    emit(state.copyWith(revokingSessionId: sessionId));

    final response = await _revokeSessionUseCase(sessionId: sessionId);

    switch (response) {
      case SuccessResponse<bool>():
        final remaining = state.sessionsState.data
            ?.where((session) => session.id != sessionId)
            .toList();

        emit(
          state.copyWith(
            sessionsState: state.sessionsState.copyWith(data: remaining),
            clearRevokingSessionId: true,
          ),
        );

      case ErrorResponse<bool>():
        emit(
          state.copyWith(
            sessionsState: state.sessionsState.copyWith(
              errorMessage: response.errorMessage,
            ),
            clearRevokingSessionId: true,
          ),
        );
    }
  }
}