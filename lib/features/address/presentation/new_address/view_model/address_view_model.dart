import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddressViewModel extends Cubit<AddressState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromLocationUseCase getAddressFromLocationUseCase;
  final GetAddressUseCase getAddressUseCase;

  AddressViewModel(
    this.getCurrentLocationUseCase,
    this.getAddressFromLocationUseCase,
    this.getAddressUseCase,
  ) : super(const AddressState());

  void doEvent(AddressEvent event) {
    switch (event) {
      case GetCurrentAddress():
        _getCurrentAddress();
        break;

      case LoadAddressDetails():
        _loadAddressDetails(event.id);
        break;

      case LocationSelected(
        latitude: final latitude,
        longitude: final longitude,
      ):
        _getAddressFromLocation(latitude: latitude, longitude: longitude);
        break;
        case AddAddress():
  _addAddress(event.address);
  break;

case EditAddress():
  _updateAddress(event.address);
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
        final current = state.addressState.data;
        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              data: response.data.copyWith(
                id: current?.id,
                phoneNumber: current?.phoneNumber,
                recipientName: current?.recipientName,
                label: current?.label,
              ),
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

  Future<void> _loadAddressDetails(String id) async {
    emit(
      state.copyWith(
        addressState: state.addressState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await getAddressUseCase.addressDetails(id);

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
      case ErrorResponse<AddressEntity>():
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
 Future<void> _addAddress(AddressEntity address) async {
  emit(
    state.copyWith(
      isSaved: false,
      addressState: state.addressState.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    ),
  );

  final response = await getAddressUseCase.addAddress(
    _toRequest(address),
  );

  switch (response) {
    case SuccessResponse<List<AddressEntity>>():
      emit(
        state.copyWith(
          isSaved: true,
          addressState: state.addressState.copyWith(
            isLoading: false,
            errorMessage: '',
          ),
        ),
      );
      break;

    case ErrorResponse<List<AddressEntity>>():
      emit(
        state.copyWith(
          isSaved: false,
          addressState: state.addressState.copyWith(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ),
      );
      break;
  }
}
Future<void> _updateAddress(AddressEntity address) async {
  final id = address.id;

  if (id == null || id.isEmpty) return;

  emit(
    state.copyWith(
      isSaved: false,
      addressState: state.addressState.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    ),
  );

  final response = await getAddressUseCase.updateAddress(
    id,
    _toRequest(address),
  );

  switch (response) {
    case SuccessResponse<List<AddressEntity>>():
      emit(
        state.copyWith(
          isSaved: true,
          addressState: state.addressState.copyWith(
            isLoading: false,
            errorMessage: '',
          ),
        ),
      );
      break;

    case ErrorResponse<List<AddressEntity>>():
      emit(
        state.copyWith(
          isSaved: false,
          addressState: state.addressState.copyWith(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ),
      );
      break;
  }
}
AddAddressRequest _toRequest(AddressEntity address) {
  return AddAddressRequest(
    recipientName: address.recipientName ?? '',
    phone: address.phoneNumber ?? '',
    addressLine: address.address ?? '',
    city: address.city ?? '',
    area: address.area ?? '',
    label: address.label ?? 'Home',
  );
}

}
