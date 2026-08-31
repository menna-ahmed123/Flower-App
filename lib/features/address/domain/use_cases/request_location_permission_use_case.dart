import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestLocationPermissionUseCase {
  final AddressRepo addressRepo;

  RequestLocationPermissionUseCase(this.addressRepo);

  Future<BaseResponse<LocationPermission>> call() {
    return addressRepo.requestLocationPermission();
  }
}
