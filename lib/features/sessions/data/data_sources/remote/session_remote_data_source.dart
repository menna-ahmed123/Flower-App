import 'package:flower_app/features/sessions/data/models/response/session_response.dart';

abstract interface class SessionRemoteDataSource {
  Future<SessionResponse> getSessions();
  Future<void> revokeSession({required String sessionId});
}