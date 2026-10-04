import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';

import '../../../../core/base/base_response.dart';

abstract interface class SessionRepo {
  Future<BaseResponse<List<SessionEntity>>> getSessions();
  Future<BaseResponse<bool>> revokeSession({required String sessionId});
}