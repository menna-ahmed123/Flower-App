import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this._dataSource, this._safeCall);

  final RegisterRemoteDataSource _dataSource;
  final SafeCall _safeCall;

  @override
  Future<BaseResponse<RegisterResult>> register(RegisterRequest request) {
    return _safeCall.safeApiCall(() => _dataSource.register(request));
  }
}
