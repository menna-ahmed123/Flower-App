import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeUseCase {
  HomeUseCase(this.repo);

  final CommerceRepo repo;

  Future<BaseResponse<HomeLayoutEntity>> call({String? storeId}) {
    return repo.getHomeLayout(storeId: storeId);
  }
}
