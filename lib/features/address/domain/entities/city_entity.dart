import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int? id;
  final int? governorateId;
  final String? nameAr;
  final String? nameEn;

  const CityEntity({
     this.id,
     this.governorateId,
     this.nameAr,
     this.nameEn,
  });
  CityEntity copyWith({
    int? id,
    int? governorateId,
    String? nameAr,
    String? nameEn,
  }) {
    return CityEntity(
      id: id ?? this.id,
      governorateId: governorateId ?? this.governorateId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }
  @override
  List<Object?> get props => [id, governorateId, nameAr, nameEn];
}