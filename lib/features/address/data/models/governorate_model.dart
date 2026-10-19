import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorate_model.g.dart';

@JsonSerializable()
class GovernorateModel {
  final int id;
  final String nameAr;
  final String nameEn;

  const GovernorateModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateModelToJson(this);
  GovernorateEntity toDomain() {
    return GovernorateEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
    );
  }
}