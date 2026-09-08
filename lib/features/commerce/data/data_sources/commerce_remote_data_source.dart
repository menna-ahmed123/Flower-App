import 'package:flower_app/features/commerce/data/models/categories_response.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/domain/entities/category_sort_by.dart';

abstract interface class CommerceRemoteDataSource {
  Future<HomeLayoutResponse> getHomeLayout({String? storeId});

  Future<ProductsResponse> getProducts({
    int? page,
    int? pageSize,
    String? occasionId,
    String? categoryId,
    String? search,
    CategorySortBy? sortBy,
  });

  Future<OccasionsResponse> getAllOccasions();

  Future<ProductDetailsResponseModel> getProductDetails(String productId);

  Future<CategoriesResponse> getAllCategories();

}
