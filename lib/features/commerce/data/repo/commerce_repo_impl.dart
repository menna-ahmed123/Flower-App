import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as:CommerceRepo)
class CommerceRepoImpl implements CommerceRepo{
  final CommerceRemoteDataSource commerceRemoteDataSource;
  final SafeCall safeCall;

  CommerceRepoImpl(this.commerceRemoteDataSource, this.safeCall);

  @override
  Future<BaseResponse<List<ProductEntity>>> getAllProducts() {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getAllProducts();
      return response.data.items
          .map((product) => product.toDomain())
          .toList();
    });
  }
}