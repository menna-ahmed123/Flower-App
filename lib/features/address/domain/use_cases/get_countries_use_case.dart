import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/country_entity.dart';
import 'package:flower_app/features/address/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCountriesUseCase {
  final AddressRepo addressRepo;

  GetCountriesUseCase(this.addressRepo);

  Future<BaseResponse<List<CountryEntity>>> call() {
    return addressRepo.getCountries();
  }
}
