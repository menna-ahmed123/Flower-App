import 'package:flower_app/features/address/data/models/governorate_model.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';

class GovernorateResponse {
  final bool? success;
  final dynamic status;
  final int? statusCode;
  final int? code;
  final String? message;
  final List<GovernorateModel> data;

  GovernorateResponse({
    this.success,
    this.status,
    this.statusCode,
    this.code,
    this.message,
    required this.data,
  });

  factory GovernorateResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<GovernorateModel> items = [];
    if (rawData is List) {
      items = rawData
          .whereType<Map>()
          .map((e) => GovernorateModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json.containsKey('nameEn') || json.containsKey('nameAr')) {
      items = [GovernorateModel.fromJson(json)];
    }

    return GovernorateResponse(
      success: json['success'] as bool?,
      status: json['status'],
      statusCode: (json['statusCode'] as num?)?.toInt(),
      code: (json['code'] as num?)?.toInt(),
      message: json['message']?.toString(),
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'statusCode': statusCode,
      'code': code,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  List<GovernorateEntity> toDomain() {
    return data.map((gov) => gov.toDomain()).toList();
  }
}
