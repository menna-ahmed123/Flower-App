import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  CommerceRepoImpl(this.commerceRemoteDataSource, this.safeCall);

  final CommerceRemoteDataSource commerceRemoteDataSource;
  final SafeCall safeCall;

  @override
  Future<BaseResponse<HomeLayoutEntity>> getHomeLayout({String? storeId}) {
    return safeCall.safeApiCall(() async {
      final response = await commerceRemoteDataSource.getHomeLayout(
        storeId: storeId,
      );
      return response.toDomain();
    });
  }
}
