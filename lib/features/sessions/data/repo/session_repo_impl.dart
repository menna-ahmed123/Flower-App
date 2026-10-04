import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/sessions/data/mapper/session_item_response_mapper.dart';
import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flower_app/features/sessions/domain/repo/session_repo.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/remote/session_remote_data_source.dart';

@Injectable(as: SessionRepo)
class SessionRepoImpl implements SessionRepo {
  final SessionRemoteDataSource _dataSource;
  final SafeCall safeCall;
  SessionRepoImpl(this._dataSource, this.safeCall);

  @override
  Future<BaseResponse<List<SessionEntity>>> getSessions() {
    return safeCall.safeApiCall(() async {
      final response = await _dataSource.getSessions();
      final items = response.data ?? [];
      return items.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<bool>> revokeSession({required String sessionId}) {
    return safeCall.safeApiCall(() async {
      await _dataSource.revokeSession(sessionId: sessionId);
      return true;
    });
  }
}