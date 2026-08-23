import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource)
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient commerceApiClient;

  CommerceRemoteDataSourceImpl(this.commerceApiClient);
  @override
  Future<ProductsResponse> getAllProducts() async {
    final response = await commerceApiClient.getAllProducts();
    return response;
  }

  /// Occasion //
  @override
  Future<OccasionsResponse> getAllOccasions() async {
    final response = await commerceApiClient.getAllOccasions();
    return response;
  }

  @override
  Future<ProductsResponse> getProductsByOccasion(String occasionId) async {
    return await commerceApiClient.getProductsByOccasion(occasionId);
  }
}
