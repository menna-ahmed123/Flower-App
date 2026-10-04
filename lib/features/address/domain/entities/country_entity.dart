import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int? id;
  final String? nameAr;
  final String? nameEn;
  final String ?code;
  final String? phoneCode;

  const CountryEntity({
     this.id,
     this.nameAr,
     this.nameEn,
     this.code,
     this.phoneCode,
  });
  CountryEntity copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    String? code,
    String? phoneCode,
  }) {
    return CountryEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
      phoneCode: phoneCode ?? this.phoneCode,
    );
  }
  @override
  List<Object?> get props => [id, nameAr, nameEn, code, phoneCode];
}