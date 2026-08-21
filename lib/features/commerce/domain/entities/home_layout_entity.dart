import 'package:equatable/equatable.dart';

class HomeLayoutEntity extends Equatable {
  const HomeLayoutEntity({required this.sections});

  final List<HomeSectionEntity> sections;

  @override
  List<Object?> get props => [sections];
}

class HomeSectionEntity extends Equatable {
  const HomeSectionEntity({
    required this.type,
    required this.id,
    required this.title,
    required this.order,
    required this.imageUrl,
    required this.deepLink,
    required this.viewAllLabel,
    required this.viewAllDeepLink,
    required this.items,
  });

  final String type;
  final String id;
  final String title;
  final int order;
  final String imageUrl;
  final String deepLink;
  final String viewAllLabel;
  final String viewAllDeepLink;
  final List<HomeRailItemEntity> items;

  @override
  List<Object?> get props => [
    type,
    id,
    title,
    order,
    imageUrl,
    deepLink,
    viewAllLabel,
    viewAllDeepLink,
    items,
  ];
}

class HomeRailItemEntity extends Equatable {
  const HomeRailItemEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.price,
    this.oldPrice,
    this.discount,
    this.deepLink,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String? price;
  final String? oldPrice;
  final String? discount;
  final String? deepLink;

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    price,
    oldPrice,
    discount,
    deepLink,
  ];
}
