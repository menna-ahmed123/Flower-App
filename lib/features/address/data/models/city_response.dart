import 'package:flower_app/features/address/data/models/city_model.dart';
import 'package:flower_app/features/address/domain/entities/city_entity.dart';

class CityResponse {
  final bool? success;
  final dynamic status;
  final int? statusCode;
  final int? code;
  final String? message;
  final List<CityModel> data;

  CityResponse({
    this.success,
    this.status,
    this.statusCode,
    this.code,
    this.message,
    required this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<CityModel> items = [];
    if (rawData is List) {
      items = rawData
          .whereType<Map>()
          .map((e) => CityModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json.containsKey('nameEn') || json.containsKey('governorateId')) {
      items = [CityModel.fromJson(json)];
    }

    return CityResponse(
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

  List<CityEntity> toDomain() {
    return data.map((city) => city.toDomain()).toList();
  }
}
