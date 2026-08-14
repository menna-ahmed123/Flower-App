import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/features/auth/register/api/register_api.dart';
import 'package:flower_app/features/auth/register/data/mappers/register_request_mapper.dart';
import 'package:flower_app/features/auth/register/data/mappers/register_result_mapper.dart';
import 'package:flower_app/features/auth/register/data/models/register_result_dto.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterApi)
class DioRegisterApi implements RegisterApi {
  DioRegisterApi(this._dio);

  final Dio _dio;

  @override
  Future<RegisterResult> register(RegisterRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: RegisterRequestMapper.toApiBody(request),
    );

    final body = response.data;
    if (!_isSuccessfulOperation(body)) {
      throw ApiException(
        message: body?['message']?.toString() ?? 'Sign up failed',
        statusCode: response.statusCode,
        errors: _operationErrors(body),
      );
    }

    final dto = RegisterResultDto.fromOperationJson(body!);
    return RegisterResultMapper.toDomain(dto);
  }

  Map<String, dynamic>? _operationErrors(Map<String, dynamic>? body) {
    final errors = body?['errors'];
    if (errors is Map<String, dynamic>) return errors;
    return null;
  }

  bool _isSuccessfulOperation(Map<String, dynamic>? body) {
    if (body == null) return false;
    if (body['data'] is! Map<String, dynamic>) return false;
    return body['isSuccess'] == true;
  }
}
