import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDeleteAddressUseCase {
  final AddressRepo repo;
  GetDeleteAddressUseCase({required this.repo});
  Future<BaseResponse<bool>> deleteAddress(String id) {
    return repo.deleteAddress(id);
  }
}
