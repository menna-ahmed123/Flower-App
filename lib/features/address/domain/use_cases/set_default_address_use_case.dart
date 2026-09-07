import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultAddressUseCase {
  final AddressRepo repo;

  SetDefaultAddressUseCase(this.repo);

  Future<BaseResponse<AddressEntity>> setDefaultAddress(String addressId) {
    return repo.setDefaultAddress(addressId);
  }
}