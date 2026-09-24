import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';

class SessionsState extends Equatable {
  final BaseState<List<SessionEntity>> sessionsState;
  final String? revokingSessionId;

  const SessionsState({
    this.sessionsState = const BaseState(),
    this.revokingSessionId,
  });

  SessionsState copyWith({
    BaseState<List<SessionEntity>>? sessionsState,
    String? revokingSessionId,
    bool clearRevokingSessionId = false,
  }) {
    return SessionsState(
      sessionsState: sessionsState ?? this.sessionsState,
      revokingSessionId: clearRevokingSessionId
          ? null
          : revokingSessionId ?? this.revokingSessionId,
    );
  }

  @override
  List<Object?> get props => [sessionsState, revokingSessionId];
}