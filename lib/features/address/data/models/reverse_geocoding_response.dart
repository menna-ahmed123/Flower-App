import 'package:flower_app/features/address/data/models/reverse_geocoding_model.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class ReverseGeocodingResponse {
  final bool? success;
  final dynamic status;
  final int? statusCode;
  final int? code;
  final String? message;
  final ReverseGeocodingModel? data;

  ReverseGeocodingResponse({
    this.success,
    this.status,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  factory ReverseGeocodingResponse.fromJson(Map<String, dynamic> json) {
    ReverseGeocodingModel? model;
    if (json['data'] is Map<String, dynamic>) {
      model = ReverseGeocodingModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    } else if (json['data'] is Map) {
      model = ReverseGeocodingModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    } else if (json.containsKey('addressLine') || json.containsKey('lat')) {
      model = ReverseGeocodingModel.fromJson(json);
    }

    return ReverseGeocodingResponse(
      success: json['success'] as bool?,
      status: json['status'],
      statusCode: (json['statusCode'] as num?)?.toInt(),
      code: (json['code'] as num?)?.toInt(),
      message: json['message']?.toString(),
      data: model,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'statusCode': statusCode,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }

  AddressEntity toDomain() {
    if (data == null) {
      return const AddressEntity();
    }
    return data!.toDomain();
  }
}
