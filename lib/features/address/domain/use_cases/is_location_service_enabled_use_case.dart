import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsLocationServiceEnabledUseCase {
  final AddressRepo addressRepo;

  IsLocationServiceEnabledUseCase(this.addressRepo);

  Future<BaseResponse<bool>> call() {
    return addressRepo.isLocationServiceEnabled();
  }
}
