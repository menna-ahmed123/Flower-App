import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/mappers/register_request_mapper.dart';
import 'package:flower_app/features/auth/register/data/mappers/register_result_mapper.dart';
import 'package:flower_app/features/auth/register/data/models/register_operation_dto.dart';
import 'package:flower_app/features/auth/register/data/models/register_result_dto.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  RegisterRemoteDataSourceImpl(this._api);

  final DioRegisterApi _api;

  @override
  Future<RegisterResult> register(RegisterRequest request) async {
    final response = await _api.register(RegisterRequestMapper.toDto(request));
    final body = response.data;

    if (!_isSuccessfulOperation(body)) {
      throw ApiException(
        message: body.message ?? 'Sign up failed',
        statusCode: response.response.statusCode,
        errors: body.errors,
      );
    }

    final data = body.data!;
    return RegisterResultMapper.toDomain(
      RegisterResultDto(
        userId: data.userId,
        email: data.email,
        role: data.role,
        status: data.status,
        message: body.message ?? '',
      ),
    );
  }

  bool _isSuccessfulOperation(RegisterOperationDto body) {
    return body.isSuccess == true && body.data != null;
  }
}
