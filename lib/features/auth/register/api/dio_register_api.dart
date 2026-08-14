import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/features/auth/register/api/register_api.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterApi)
class DioRegisterApi implements RegisterApi {
  DioRegisterApi(this._dio);

  final Dio _dio;

  @override
  Future<RegisterResult> register(RegisterRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: _toRequestBody(request),
    );

    final body = response.data;
    if (!_isSuccessfulOperation(body)) {
      throw ApiException(
        message: body?['message']?.toString() ?? 'Sign up failed',
        statusCode: response.statusCode,
        errors: _operationErrors(body),
      );
    }

    return RegisterResult.fromOperationJson(body!);
  }

  Map<String, dynamic>? _operationErrors(Map<String, dynamic>? body) {
    final errors = body?['errors'];
    if (errors is Map<String, dynamic>) return errors;
    return null;
  }

  bool _isSuccessfulOperation(Map<String, dynamic>? body) {
    if (body == null) return false;
    if (body['data'] is! Map<String, dynamic>) return false;
    final isSuccess = body['isSuccess'];
    return isSuccess == null || isSuccess == true;
  }

  Map<String, dynamic> _toRequestBody(RegisterRequest request) {
    return {
      'fullName': '${request.firstName} ${request.lastName}'.trim(),
      'email': request.email,
      'phoneNumber': request.phoneNumber,
      'gender': request.gender == Gender.female ? 'Female' : 'Male',
      'password': request.password,
      // API requires confirmPassword; UI already validated the match.
      'confirmPassword': request.password,
    };
  }
}
