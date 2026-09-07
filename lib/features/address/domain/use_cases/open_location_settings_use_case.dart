import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class OpenLocationSettingsUseCase {
  final AddressRepo addressRepo;

  OpenLocationSettingsUseCase(this.addressRepo);

  Future<BaseResponse<bool>> call() {
    return addressRepo.openLocationSettings();
  }
}
