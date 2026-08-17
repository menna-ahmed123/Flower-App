import 'package:flower_app/features/auth/register/data/models/register_result_dto.dart';

class RegisterOperationDto {
  const RegisterOperationDto({
    this.isSuccess,
    this.statusCode,
    this.message,
    this.data,
    this.errors,
  });

  final bool? isSuccess;
  final int? statusCode;
  final String? message;
  final RegisterResultDto? data;
  final Map<String, dynamic>? errors;

  factory RegisterOperationDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final errors = json['errors'];
    return RegisterOperationDto(
      isSuccess: json['isSuccess'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message']?.toString(),
      data: data is Map<String, dynamic>
          ? RegisterResultDto.fromJson(data)
          : null,
      errors: errors is Map<String, dynamic> ? errors : null,
    );
  }
}
