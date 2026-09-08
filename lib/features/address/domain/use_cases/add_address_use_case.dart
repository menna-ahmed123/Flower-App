
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {
  final AddressRepo repo;
  AddAddressUseCase({required this.repo});
  Future<BaseResponse<AddressEntity>> addAddress(
    AddAddressRequest request,
  ) {
    return repo.createAddress(request);
  }
}