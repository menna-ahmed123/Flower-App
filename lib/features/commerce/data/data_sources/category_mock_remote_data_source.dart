import 'package:flower_app/core/dummy/dummy_network.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/category_model.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource, env: ['mock'])
class CommerceMockRemoteDataSource implements CommerceRemoteDataSource {
  @override
  Future<CategoriesResponse> getAllCategories() async {
    await DummyNetwork.wait();
    return CategoriesResponse(
      success: true,
      statusCode: 200,
      message: 'Categories loaded successfully',
      messageLocalized: 'تم تحميل الأقسام بنجاح',
      data: mockCategoriesData(),
    );
  }
@override
  Future<ProductsResponse> getProductsByCategory(String categoryId) async {
    await DummyNetwork.wait();
    final products = mockProductsData(categoryId);
    return ProductsResponse(
      success: true,
      // الأرجومنت المطلوب للـ Constructor
      statusCode: 200,
      message: 'Products loaded successfully',
      messageLocalized: 'تم تحميل المنتجات بنجاح',
      data: ProductsDataDto(
        page: 1,
        pageSize: 10,
        totalCount: products.length,
        items: products,
      ),
    );
  }


  @override
  Future<ProductsResponse> getAllProducts() async => throw UnimplementedError();

  @override
  Future<OccasionsResponse> getAllOccasions() async =>
      throw UnimplementedError();

  @override
  Future<ProductsResponse> getProductsByOccasion(String occasionId) async =>
      throw UnimplementedError();

  @override
  Future<ProductDetailsResponseModel> getProductDetails(
    String productId,
  ) async => throw UnimplementedError();
}


List<CategoryModel> mockCategoriesData() {
  return const [
    CategoryModel(
      id: 'cat-1',
      name: 'Flowers',
      imageUrl: 'https://picsum.photos/seed/rose/200/200',
    ),
    CategoryModel(
      id: 'cat-2',
      name: 'Gifts',
      imageUrl: 'https://picsum.photos/seed/gift/200/200',
    ),
    CategoryModel(
      id: 'cat-3',
      name: 'Cards',
      imageUrl: 'https://picsum.photos/seed/card/200/200',
    ),
    CategoryModel(
      id: 'cat-4',
      name: 'Jewelry',
      imageUrl: 'https://picsum.photos/seed/jewel/200/200',
    ),
  ];
}

List<ProductDto> mockProductsData(String categoryId) {
  return [
    ProductDto(
      id: 'prod-1',
      name: 'Red Roses Bouquet ($categoryId)',
      imageUrl: 'https://picsum.photos/seed/roses/400/400',
      price: 450.0,
      discountedPrice: 400.0,
      discountPercent: 11.0,
      inStock: true,
    ),
    ProductDto(
      id: 'prod-2',
      name: 'Spring Tulips ($categoryId)',
      imageUrl: 'https://picsum.photos/seed/tulips/400/400',
      price: 600.0,
      discountedPrice: 600.0,
      discountPercent: 0.0,
      inStock: true,
    ),
    ProductDto(
      id: 'prod-3',
      name: 'Sunflowers Box ($categoryId)',
      imageUrl: 'https://picsum.photos/seed/sunflower/400/400',
      price: 350.0,
      discountedPrice: 300.0,
      discountPercent: 14.0,
      inStock: false,
    ),
  ];
}
