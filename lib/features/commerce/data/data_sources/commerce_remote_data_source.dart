import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';

abstract interface class CommerceRemoteDataSource {
  Future<HomeLayoutResponse> getHomeLayout({String? storeId});
}
