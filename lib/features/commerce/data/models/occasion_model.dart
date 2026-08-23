import 'package:json_annotation/json_annotation.dart';

part 'occasion_model.g.dart';

@JsonSerializable()
class OccasionModel {
  final String id;
  final String name;
  final String imageUrl;
  final int sortOrder;

  OccasionModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
  });

  factory OccasionModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionModelToJson(this);
}