import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGovernoratesUseCase {
  final AddressRepo addressRepo;

  GetGovernoratesUseCase(this.addressRepo);

  Future<BaseResponse<List<GovernorateEntity>>> call() {
    return addressRepo.getGovernorates();
  }
}
