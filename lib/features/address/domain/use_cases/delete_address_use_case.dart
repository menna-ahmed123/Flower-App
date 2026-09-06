import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepo repo;
  DeleteAddressUseCase({required this.repo});
  Future<BaseResponse<bool>> deleteAddress(String id) {
    return repo.deleteAddress(id);
  }
}
