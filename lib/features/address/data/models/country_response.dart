import 'package:flower_app/features/address/data/models/country_model.dart';
import 'package:flower_app/features/address/domain/entities/country_entity.dart';

class CountryResponse {
  final bool? success;
  final dynamic status;
  final int? statusCode;
  final int? code;
  final String? message;
  final List<CountryModel> data;

  CountryResponse({
    this.success,
    this.status,
    this.statusCode,
    this.code,
    this.message,
    required this.data,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<CountryModel> items = [];
    if (rawData is List) {
      items = rawData
          .whereType<Map>()
          .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json.containsKey('nameEn') || json.containsKey('code')) {
      items = [CountryModel.fromJson(json)];
    }

    return CountryResponse(
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

  List<CountryEntity> toDomain() {
    return data.map((country) => country.toDomain()).toList();
  }
}
