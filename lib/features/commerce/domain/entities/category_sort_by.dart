import 'package:flower_app/core/constants/app_string.dart';

enum CategorySortBy {
  lowestPrice(1),
  highestPrice(2),
  newest(3),
  oldest(4),
  discount(5);

  final int value;
  const CategorySortBy(this.value);

  String get title {
    switch (this) {
      case CategorySortBy.lowestPrice:
        return AppString.lowestPrice;
      case CategorySortBy.highestPrice:
        return AppString.highestPrice;
      case CategorySortBy.newest:
        return AppString.newest;
      case CategorySortBy.oldest:
        return AppString.oldest;
      case CategorySortBy.discount:
        return AppString.discount;
    }
  }
}
