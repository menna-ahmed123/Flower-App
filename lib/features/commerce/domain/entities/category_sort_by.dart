import 'package:flower_app/core/constants/app_string.dart';

enum CategorySortBy {
  lowestPrice(1, 'PriceLowToHigh'),
  highestPrice(2, 'PriceHighToLow'),
  newest(3, 'Newest'),
  oldest(4, 'Oldest'),
  discount(5, 'Discount');

  final int value;
  final String apiValue;
  const CategorySortBy(this.value, this.apiValue);

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
