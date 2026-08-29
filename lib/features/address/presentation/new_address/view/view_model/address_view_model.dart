import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddressViewModel extends Cubit<AddressState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromLocationUseCase getAddressFromLocationUseCase;

  AddressViewModel(
    this.getCurrentLocationUseCase,
    this.getAddressFromLocationUseCase,
  ) : super(const AddressState());

  Future<void> doEvent(AddressEvent event) async {
    switch (event) {
      case GetCurrentAddress():
      await _getCurrentAddress();
        break;

      case LocationSelected(
        latitude: final latitude,
        longitude: final longitude,
      ):
       await _getAddressFromLocation(latitude: latitude, longitude: longitude);
        break;
    }
  }

  Future<void> _getCurrentAddress() async {
    emit(
      state.copyWith(
        locationState: state.locationState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        addressState: state.addressState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final locationResponse = await getCurrentLocationUseCase();

    switch (locationResponse) {
      case SuccessResponse<LocationEntity>():
        final location = locationResponse.data;

        emit(
          state.copyWith(
            locationState: state.locationState.copyWith(
              isLoading: false,
              data: location,
              errorMessage: '',
            ),
          ),
        );

        await _getAddressFromLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            locationState: state.locationState.copyWith(
              isLoading: false,
              errorMessage: locationResponse.errorMessage,
            ),
            addressState: state.addressState.copyWith(
              isLoading: false,
              errorMessage: locationResponse.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _getAddressFromLocation({
    required double latitude,
    required double longitude,
  }) async {
    emit(
      state.copyWith(
        addressState: state.addressState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await getAddressFromLocationUseCase(
      latitude: latitude,
      longitude: longitude,
    );

    switch (response) {
      case SuccessResponse<AddressEntity>():
        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
