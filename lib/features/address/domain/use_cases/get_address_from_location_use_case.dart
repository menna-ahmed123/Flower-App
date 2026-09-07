import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressFromLocationUseCase {
  final AddressRepo  addressRepo;

  GetAddressFromLocationUseCase(this.addressRepo);

  Future<BaseResponse<AddressEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return addressRepo.getAddressFromLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
