import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_layout_response.g.dart';

@JsonSerializable()
class HomeLayoutResponse {
  HomeLayoutResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @JsonKey(defaultValue: true)
  final bool isSuccess;
  @JsonKey(defaultValue: 200)
  final int statusCode;
  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(fromJson: homeSectionsFromJson, toJson: homeSectionsToJson)
  final List<HomeSectionDto> data;

  factory HomeLayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeLayoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeLayoutResponseToJson(this);

  HomeLayoutEntity toDomain() {
    final sections = [...data]..sort((a, b) => a.order.compareTo(b.order));
    return HomeLayoutEntity(
      sections: [
        for (final section in sections)
          if (section.enabled) section.toDomain(),
      ],
    );
  }
}

@JsonSerializable()
class HomeSectionDto {
  HomeSectionDto({
    required this.type,
    required this.id,
    this.title,
    required this.order,
    required this.enabled,
    required this.payload,
  });

  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String id;
  final String? title;
  @JsonKey(defaultValue: 0)
  final int order;
  @JsonKey(defaultValue: true)
  final bool enabled;
  @JsonKey(fromJson: homePayloadFromJson)
  final Map<String, dynamic> payload;

  factory HomeSectionDto.fromJson(Map<String, dynamic> json) =>
      _$HomeSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeSectionDtoToJson(this);

  HomeSectionEntity toDomain() {
    return HomeSectionEntity(
      type: type,
      id: id,
      title: title ?? '',
      order: order,
      imageUrl: payload['imageUrl']?.toString() ?? '',
      deepLink: payload['deepLink']?.toString() ?? '',
      viewAllLabel: _viewAll['label']?.toString() ?? '',
      viewAllDeepLink: _viewAll['deepLink']?.toString() ?? '',
      items: _items,
    );
  }

  Map<String, dynamic> get _viewAll {
    final raw = payload['viewAll'];
    if (raw is! Map) return const {};
    return Map<String, dynamic>.from(raw);
  }

  List<HomeRailItemEntity> get _items {
    final raw = payload['items'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map) homeRailItemFromJson(Map<String, dynamic>.from(item)),
    ];
  }
}

List<HomeSectionDto> homeSectionsFromJson(dynamic json) {
  if (json is List) {
    return [
      for (final item in json)
        if (item is Map)
          HomeSectionDto.fromJson(Map<String, dynamic>.from(item)),
    ];
  }
  if (json is Map) return homeSectionsFromJson(json['sections']);
  return const [];
}

List<Map<String, dynamic>> homeSectionsToJson(List<HomeSectionDto> sections) {
  return [for (final section in sections) section.toJson()];
}

Map<String, dynamic> homePayloadFromJson(dynamic json) {
  if (json is Map) return Map<String, dynamic>.from(json);
  return const {};
}

HomeRailItemEntity homeRailItemFromJson(Map<String, dynamic> json) {
  return HomeRailItemEntity(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    imageUrl: json['imageUrl']?.toString() ?? '',
    price: json['price']?.toString(),
    oldPrice: json['oldPrice']?.toString(),
    discount: json['discount']?.toString(),
    deepLink: json['deepLink']?.toString(),
  );
}
