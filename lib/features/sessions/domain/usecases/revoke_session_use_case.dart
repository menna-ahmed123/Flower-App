import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../repo/session_repo.dart';

@Injectable()
class RevokeSessionUseCase {
  final SessionRepo _repo;
  RevokeSessionUseCase(this._repo);

  Future<BaseResponse<bool>> call({required String sessionId}) {
    return _repo.revokeSession(sessionId: sessionId);
  }
}