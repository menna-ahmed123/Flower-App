import 'package:flower_app/core/di/app_environment.dart';
import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource, env: [AppEnvironment.prod])
class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  CommerceRemoteDataSourceImpl(this.commerceApiClient);

  final CommerceApiClient commerceApiClient;

  @override
  Future<HomeLayoutResponse> getHomeLayout({String? storeId}) {
    return commerceApiClient.getHomeLayout(storeId: storeId);
  }
}
