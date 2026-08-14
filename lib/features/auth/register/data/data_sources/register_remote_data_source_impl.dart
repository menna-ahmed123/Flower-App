import 'package:flower_app/features/auth/register/api/register_api.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  RegisterRemoteDataSourceImpl(this._api);

  final RegisterApi _api;

  @override
  Future<RegisterResult> register(RegisterRequest request) {
    return _api.register(request);
  }
}
