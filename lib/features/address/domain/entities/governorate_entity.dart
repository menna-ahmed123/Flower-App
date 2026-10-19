import 'package:equatable/equatable.dart';

class GovernorateEntity extends Equatable {
  final int? id;
  final String? nameAr;
  final String? nameEn;

  const GovernorateEntity({
     this.id,
     this.nameAr,
     this.nameEn,
  });
  GovernorateEntity copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
  }) {
    return GovernorateEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }
  @override
  List<Object?> get props => [id, nameAr, nameEn];
}