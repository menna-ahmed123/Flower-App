import 'package:flower_app/features/sessions/api/session_api_client.dart';
import 'package:flower_app/features/sessions/data/data_sources/remote/session_remote_data_source.dart';
import 'package:flower_app/features/sessions/data/models/response/session_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SessionRemoteDataSource)
class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final SessionApiClient _sessionApiClient;
  SessionRemoteDataSourceImpl(this._sessionApiClient);

  @override
  Future<SessionResponse> getSessions() {
    return _sessionApiClient.getSessions();
  }

  @override
  Future<void> revokeSession({required String sessionId}) {
    return _sessionApiClient.revokeSession(sessionId);
  }
}