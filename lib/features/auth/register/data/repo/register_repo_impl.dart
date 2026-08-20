import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/repo/register_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRepo)
class RegisterRepositoryImpl implements RegisterRepo {
  final RegisterRemoteDataSource remoteDatasource;
  final SafeCall safeCall;

  RegisterRepositoryImpl(this.remoteDatasource, this.safeCall);

  @override
  Future<BaseResponse<RegisterEntity>> register(RegisterRequest request) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDatasource.register(request);
      final data = response.data;
      if (!response.isSuccess || data == null) {
        throw ApiException(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
      return data.toDomain(message: response.message);
    });
  }
}
