import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';

abstract interface class AddressRepo {
  Future<BaseResponse<AddressEntity>> getAddressFromLocation({
    required double latitude,
    required double longitude,
  });
  Future<BaseResponse<LocationEntity>> getCurrentLocation();
}
