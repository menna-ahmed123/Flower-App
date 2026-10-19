import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  final int id;
  final int governorateId;
  final String nameAr;
  final String nameEn;

  const CityModel({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
  CityEntity toDomain() {
    return CityEntity(
      id: id,
      governorateId: governorateId,
      nameAr: nameAr,
      nameEn: nameEn,
    );
  } 
}