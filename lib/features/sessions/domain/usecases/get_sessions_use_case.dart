import 'package:flower_app/features/sessions/domain/repo/session_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../entities/session_entity.dart';

@Injectable()
class GetSessionsUseCase {
  final SessionRepo _repo;
  GetSessionsUseCase(this._repo);

  Future<BaseResponse<List<SessionEntity>>> call() {
    return _repo.getSessions();
  }
}