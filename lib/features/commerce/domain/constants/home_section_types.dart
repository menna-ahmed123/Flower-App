abstract final class HomeSectionTypes {
  static const String banner = 'banner';
  static const String categoryRail = 'category_rail';
  static const String categories = 'Categories';
  static const String occasionRail = 'occasion_rail';
  static const String occasions = 'Occasions';
  static const String productRail = 'product_rail';
  static const String bestSeller = 'BestSeller';
  static const String productsCarousel = 'ProductsCarousel';

  static const Set<String> productSections = {
    productRail,
    bestSeller,
    productsCarousel,
  };

  static bool isProductSection(String type) => productSections.contains(type);
}
