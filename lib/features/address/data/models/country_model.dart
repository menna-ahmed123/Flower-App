import 'package:flower_app/features/address/domain/entities/country_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String code;
  final String phoneCode;

  const CountryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.phoneCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
  CountryEntity toDomain() {
    return CountryEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      code: code,
      phoneCode: phoneCode,
    );
  }
}