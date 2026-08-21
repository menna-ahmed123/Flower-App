import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/core/dummy/dummy_network.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource, env: [AppEnvironment.mock])
class CommerceMockRemoteDataSource implements CommerceRemoteDataSource {
  @override
  Future<HomeLayoutResponse> getHomeLayout({String? storeId}) async {
    await DummyNetwork.wait();
    return HomeLayoutResponse(
      isSuccess: true,
      statusCode: 200,
      message: 'Home layout loaded',
      data: mockHomeSections(),
    );
  }
}

List<HomeSectionDto> mockHomeSections() {
  return [
    mockBannerSection(),
    mockCategorySection(),
    mockProductSection(),
    mockOccasionSection(),
  ];
}

HomeSectionDto mockBannerSection() {
  return HomeSectionDto(
    type: 'banner',
    id: 'banner-home',
    title: '',
    order: 1,
    enabled: true,
    payload: {
      'imageUrl': 'https://picsum.photos/seed/flowery-banner/800/360',
      'deepLink': '/products?collection=summer',
    },
  );
}

HomeSectionDto mockCategorySection() {
  return HomeSectionDto(
    type: 'category_rail',
    id: 'categories',
    title: 'Categories',
    order: 2,
    enabled: true,
    payload: {
      'items': mockCategoryItems(),
      'viewAll': {'label': 'View All', 'deepLink': '/categories'},
    },
  );
}

List<Map<String, String>> mockCategoryItems() {
  return [
    mockRailItem('cat-1', 'Flowers', 'rose', '/categories'),
    mockRailItem('cat-2', 'Gift', 'gift', '/categories'),
    mockRailItem('cat-3', 'Card', 'card', '/categories'),
    mockRailItem('cat-4', 'Jewellery', 'jewel', '/categories'),
  ];
}

HomeSectionDto mockProductSection() {
  return HomeSectionDto(
    type: 'product_rail',
    id: 'best-seller',
    title: 'Best seller',
    order: 3,
    enabled: true,
    payload: {
      'items': mockProductItems(),
      'viewAll': {'label': 'View All', 'deepLink': '/products'},
    },
  );
}

List<Map<String, String>> mockProductItems() {
  return [
    mockProductItem('prod-1', 'Sunny', 'sunflower'),
    mockProductItem('prod-2', 'Red roses', 'roses'),
    mockProductItem('prod-3', 'Spring vase', 'tulips'),
  ];
}

HomeSectionDto mockOccasionSection() {
  return HomeSectionDto(
    type: 'occasion_rail',
    id: 'occasions',
    title: 'Occasion',
    order: 4,
    enabled: true,
    payload: {
      'items': mockOccasionItems(),
      'viewAll': {'label': 'View All', 'deepLink': '/occasions'},
    },
  );
}

List<Map<String, String>> mockOccasionItems() {
  return [
    mockRailItem('occ-1', 'Wedding', 'wedding', '/occasions'),
    mockRailItem('occ-2', 'Birthday', 'birthday', '/occasions'),
    mockRailItem('occ-3', 'Graduation', 'graduation', '/occasions'),
  ];
}

Map<String, String> mockRailItem(
  String id,
  String name,
  String seed,
  String deepLink,
) {
  return {
    'id': id,
    'name': name,
    'imageUrl': 'https://picsum.photos/seed/$seed/200/200',
    'deepLink': deepLink,
  };
}

Map<String, String> mockProductItem(String id, String name, String seed) {
  return {
    'id': id,
    'name': name,
    'imageUrl': 'https://picsum.photos/seed/$seed/400/400',
    'price': '600 EGP',
    'deepLink': '/product_details',
  };
}
