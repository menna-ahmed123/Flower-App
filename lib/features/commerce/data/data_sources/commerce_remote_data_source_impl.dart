import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/product_details_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource)
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient commerceApiClient;
  final SafeCall safeCall;

  CommerceRemoteDataSourceImpl(this.commerceApiClient, this.safeCall);

  @override
  Future<BaseResponse<ProductDetailsResponseModel>> getProductDetails({
    required String productId,
  }) {
    return safeCall.safeApiCall(
      () => commerceApiClient.getProductDetails(productId),
    );
  }
}
