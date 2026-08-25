import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class OccasionUseCase {
  final CommerceRepo repo;

  OccasionUseCase(this.repo);

  Future<BaseResponse<List<OccasionModel>>> call() {
    return repo.getAllOccasions();
  }
}