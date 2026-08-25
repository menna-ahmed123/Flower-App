import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/catalog_items_response.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource)
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient _commerceApiClient;

  CommerceRemoteDataSourceImpl(this._commerceApiClient);

  @override
  Future<HomeLayoutResponse> getHomeLayout({String? storeId}) async {
    final layout = await _commerceApiClient.getHomeLayout(storeId: storeId);
    return HomeLayoutResponse(
      isSuccess: layout.isSuccess,
      statusCode: layout.statusCode,
      message: layout.message,
      data: [for (final section in layout.data) await _hydrateSection(section)],
    );
  }

  @override
  Future<ProductsResponse> getProducts({
    String? occasionId,
    String? categoryId,
  }) {
    return _commerceApiClient.getProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );
  }

  @override
  Future<CategoriesResponse> getAllCategories() {
    return _commerceApiClient.getAllCategories();
  }

  @override
  Future<OccasionsResponse> getAllOccasions() {
    return _commerceApiClient.getAllOccasions();
  }

  @override
  Future<ProductDetailsResponseModel> getProductDetails(String productId) {
    return _commerceApiClient.getProductDetails(productId);
  }

  Future<HomeSectionDto> _hydrateSection(HomeSectionDto section) async {
    if (section.type == 'banner') return _bannerSection(section);
    final items = await _itemsFor(section);
    if (items.isEmpty) return section;
    return _copySection(section, {...section.payload, 'items': items});
  }

  Future<List<Map<String, dynamic>>> _itemsFor(HomeSectionDto section) {
    final take = _take(section);
    return switch (section.type) {
      'category_rail' => _railItems(
        () => _commerceApiClient.getCategories(),
        take,
        _categoryItem,
      ),
      'occasion_rail' => _railItems(
        () => _commerceApiClient.getOccasions(),
        take,
        _occasionItem,
      ),
      'product_rail' => _railItems(
        () => _commerceApiClient.getCatalogProducts(page: 1, pageSize: take),
        take,
        _productItem,
      ),
      _ => Future.value(const []),
    };
  }
}

int _take(HomeSectionDto section) {
  final raw = section.payload['take'];
  if (raw is num) return raw.toInt();
  return 10;
}

Future<List<Map<String, dynamic>>> _railItems(
  Future<CatalogItemsResponse> Function() load,
  int take,
  Map<String, dynamic> Function(Map<String, dynamic> json) mapItem,
) async {
  final items = await load();
  return [for (final item in items.items.take(take)) mapItem(item)];
}

Map<String, dynamic> _categoryItem(Map<String, dynamic> json) {
  return {
    'id': json['id']?.toString() ?? '',
    'name': json['name']?.toString() ?? '',
    'imageUrl': ApiEndpoints.mediaUrl(json['imageUrl']?.toString()),
    'deepLink': json['deepLink']?.toString() ?? '/categories',
  };
}

Map<String, dynamic> _occasionItem(Map<String, dynamic> json) {
  return {
    'id': json['id']?.toString() ?? '',
    'name': json['name']?.toString() ?? '',
    'imageUrl': ApiEndpoints.mediaUrl(json['imageUrl']?.toString()),
    'deepLink': '/occasions',
  };
}

Map<String, dynamic> _productItem(Map<String, dynamic> json) {
  final sale = json['discountedPrice'];
  return {
    'id': json['id']?.toString() ?? '',
    'name': json['name']?.toString() ?? '',
    'imageUrl': ApiEndpoints.mediaUrl(json['imageUrl']?.toString()),
    'price': (sale ?? json['price'])?.toString(),
    'oldPrice': sale == null ? null : json['price']?.toString(),
    'discount': json['discountPercent']?.toString(),
    'deepLink': '/products/${json['id']}',
  };
}

HomeSectionDto _bannerSection(HomeSectionDto section) {
  final given = section.payload['imageUrl']?.toString() ?? '';
  if (given.isEmpty) return section;
  return _copySection(section, {
    ...section.payload,
    'imageUrl': ApiEndpoints.mediaUrl(given),
  });
}

HomeSectionDto _copySection(
  HomeSectionDto section,
  Map<String, dynamic> payload,
) {
  return HomeSectionDto(
    type: section.type,
    id: section.id,
    title: section.title,
    order: section.order,
    enabled: section.enabled,
    payload: payload,
  );
}
