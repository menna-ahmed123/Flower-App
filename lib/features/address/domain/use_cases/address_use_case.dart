import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressUseCase {
  final AddressRepo repo;
  GetAddressUseCase({required this.repo});

  Future<BaseResponse<List<AddressEntity>>> getAddresses() {
    return repo.getAddresses();
  }

  Future<BaseResponse<List<AddressEntity>>> addAddress(
    AddAddressRequest request,
  ) {
    return repo.addAddress(request);
  }

  Future<BaseResponse<bool>> deleteAddress(String id) {
    return repo.deleteAddress(id);
  }
}
