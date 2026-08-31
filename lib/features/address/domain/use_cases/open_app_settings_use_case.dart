import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class OpenAppSettingsUseCase {
  final AddressRepo addressRepo;

  OpenAppSettingsUseCase(this.addressRepo);

  Future<BaseResponse<bool>> call() {
    return addressRepo.openAppSettings();
  }
}
