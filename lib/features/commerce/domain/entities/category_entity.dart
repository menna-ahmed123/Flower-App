import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final String? iconUrl;
  final int? displayOrder;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? lastChangedBy;

  const CategoryEntity({
    this.id,
    this.name,
    this.iconUrl,
    this.displayOrder,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.lastChangedBy,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    iconUrl,
    displayOrder,
    isDeleted,
    createdAt,
    updatedAt,
    lastChangedBy,
  ];
}
