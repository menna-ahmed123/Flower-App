import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentLocationUseCase {
  final AddressRepo addressRepo;

  GetCurrentLocationUseCase(this.addressRepo);

  Future<BaseResponse<LocationEntity>> call() {
    return addressRepo.getCurrentLocation();
  }
}
