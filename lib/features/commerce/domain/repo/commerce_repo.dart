import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';

abstract interface class CommerceRepo {
  Future<BaseResponse<HomeLayoutEntity>> getHomeLayout({String? storeId});
}
