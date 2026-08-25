// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_layout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeLayoutResponse _$HomeLayoutResponseFromJson(Map<String, dynamic> json) =>
    HomeLayoutResponse(
      isSuccess: json['isSuccess'] as bool? ?? true,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message'] as String? ?? '',
      data: homeSectionsFromJson(json['data']),
    );

Map<String, dynamic> _$HomeLayoutResponseToJson(HomeLayoutResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': homeSectionsToJson(instance.data),
    };

HomeSectionDto _$HomeSectionDtoFromJson(Map<String, dynamic> json) =>
    HomeSectionDto(
      type: json['type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      enabled: json['enabled'] as bool? ?? true,
      payload: homePayloadFromJson(json['payload']),
    );

Map<String, dynamic> _$HomeSectionDtoToJson(HomeSectionDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'title': instance.title,
      'order': instance.order,
      'enabled': instance.enabled,
      'payload': instance.payload,
    };
