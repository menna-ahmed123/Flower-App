import 'package:json_annotation/json_annotation.dart';

part 'occasion_model.g.dart';

/// Occasion as returned by GET /api/catalog/occasions (new API format).
@JsonSerializable()
class OccasionModel {
  OccasionModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.displayOrder,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'imageUrl', defaultValue: '')
  final String imageUrl;

  /// New name for sort order (was: sortOrder in old API).
  @JsonKey(name: 'displayOrder', defaultValue: 0)
  final int displayOrder;

  @JsonKey(name: 'isActive')
  final bool? isActive;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  @JsonKey(name: 'lastChangedBy')
  final String? lastChangedBy;

  factory OccasionModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionModelToJson(this);
}
