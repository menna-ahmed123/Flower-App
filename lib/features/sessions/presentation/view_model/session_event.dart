sealed class SessionsEvent {}

class LoadSessions extends SessionsEvent {}

class RevokeSession extends SessionsEvent {
  final String sessionId;

  RevokeSession(this.sessionId);
}