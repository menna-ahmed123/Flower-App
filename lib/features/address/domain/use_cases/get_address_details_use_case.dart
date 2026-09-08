import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressDetailsUseCase {
  final AddressRepo repo;
  GetAddressDetailsUseCase({required this.repo});
  
  Future<BaseResponse<AddressEntity>> addressDetails(String id) {
    return repo.addressDetails(id);
  }

}