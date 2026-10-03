import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_layout_response.g.dart';

// ---------------------------------------------------------------------------
// Top-level wrapper
// New API format: { status, code, message, data: [...], pagination, errors }
// ---------------------------------------------------------------------------
@JsonSerializable()
class HomeLayoutResponse {
  HomeLayoutResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  @JsonKey(name: 'status', defaultValue: true)
  final bool status;
  @JsonKey(name: 'code', defaultValue: 200)
  final int code;
  @JsonKey(name: 'message', defaultValue: '')
  final String message;
  @JsonKey(name: 'data', fromJson: homeSectionsFromJson, toJson: homeSectionsToJson)
  final List<HomeSectionDto> data;

  factory HomeLayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeLayoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeLayoutResponseToJson(this);

  bool get isSuccess => status && (code >= 200 && code < 300);

  HomeLayoutEntity toDomain() {
    final sections = [...data]..sort((a, b) => a.order.compareTo(b.order));
    return HomeLayoutEntity(
      sections: [
        for (final section in sections)
          if (section.isEnabled) section.toDomain(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section DTO
// New fields: isEnabled (was: enabled), payload now has embedded items
// ---------------------------------------------------------------------------
@JsonSerializable()
class HomeSectionDto {
  HomeSectionDto({
    required this.id,
    required this.type,
    this.title,
    required this.order,
    required this.isEnabled,
    required this.payload,
  });

  @JsonKey(name: 'id', defaultValue: '')
  final String id;
  @JsonKey(name: 'type', defaultValue: '')
  final String type;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'order', defaultValue: 0)
  final int order;
  @JsonKey(name: 'isEnabled', defaultValue: true)
  final bool isEnabled;
  @JsonKey(name: 'payload', fromJson: homePayloadFromJson)
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
      imageUrl: ApiEndpoints.mediaUrl(payload['imageUrl']?.toString()),
      deepLink: payload['clickAction']?.toString() ?? '',
      viewAllLabel: '',
      viewAllDeepLink: payload['viewAllAction']?.toString() ?? '',
      items: _items,
    );
  }

  List<HomeRailItemEntity> get _items {
    final raw = payload['items'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map)
          _railItemFromJson(Map<String, dynamic>.from(item), type),
    ];
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

List<HomeSectionDto> homeSectionsFromJson(dynamic json) {
  if (json is List) {
    return [
      for (final item in json)
        if (item is Map)
          HomeSectionDto.fromJson(Map<String, dynamic>.from(item)),
    ];
  }
  return const [];
}

List<Map<String, dynamic>> homeSectionsToJson(List<HomeSectionDto> sections) =>
    [for (final s in sections) s.toJson()];

Map<String, dynamic> homePayloadFromJson(dynamic json) {
  if (json is Map) return Map<String, dynamic>.from(json);
  return const {};
}

/// Builds a [HomeRailItemEntity] from a raw JSON map.
/// Categories use [iconUrl]; products & occasions use [imageUrl].
HomeRailItemEntity _railItemFromJson(
  Map<String, dynamic> json,
  String sectionType,
) {
  // Categories use iconUrl; everything else uses imageUrl
  final rawImage = sectionType == 'category_rail'
      ? json['iconUrl']?.toString()
      : json['imageUrl']?.toString();

  final price = json['price'];
  final discountedPrice = json['discountedPrice'] ?? json['discountPrice'];

  return HomeRailItemEntity(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    imageUrl: ApiEndpoints.mediaUrl(rawImage),
    price: (discountedPrice ?? price)?.toString(),
    oldPrice: discountedPrice != null ? price?.toString() : null,
    discount: json['discountPercent']?.toString() ??
        json['discountPercentage']?.toString(),
    deepLink: json['deepLink']?.toString(),
  );
}
