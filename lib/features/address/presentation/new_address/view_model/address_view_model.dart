
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_details_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/is_location_service_enabled_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/open_location_settings_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/request_location_permission_use_case.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AddressViewModel extends Cubit<AddressState> {
  final IsLocationServiceEnabledUseCase
      isLocationServiceEnabledUseCase;

  final CheckLocationPermissionUseCase
      checkLocationPermissionUseCase;

  final RequestLocationPermissionUseCase
      requestLocationPermissionUseCase;

  final OpenLocationSettingsUseCase
      openLocationSettingsUseCase;

  final OpenAppSettingsUseCase openAppSettingsUseCase;

  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  final GetAddressFromLocationUseCase
      getAddressFromLocationUseCase;

  final GetAddressDetailsUseCase getAddressDetailsUseCase;

  AddressViewModel(
    this.isLocationServiceEnabledUseCase,
    this.checkLocationPermissionUseCase,
    this.requestLocationPermissionUseCase,
    this.openLocationSettingsUseCase,
    this.openAppSettingsUseCase,
    this.getCurrentLocationUseCase,
    this.getAddressFromLocationUseCase,
    this.getAddressDetailsUseCase,
  ) : super(const AddressState());

  Future<void> doEvent(AddressEvent event) async {
    switch (event) {
      case GetCurrentAddress():
        await _getCurrentAddress();
        break;

      case LoadAddressDetails():
        await _loadAddressDetails(event.id);
        break;

      case LocationSelected(
          latitude: final latitude,
          longitude: final longitude,
        ):
        await _getAddressFromLocation(
          latitude: latitude,
          longitude: longitude,
        );
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

    final serviceResponse =
        await isLocationServiceEnabledUseCase();

    switch (serviceResponse) {
      case SuccessResponse<bool>():
        if (!serviceResponse.data) {
          _emitLocationError(
            AppString.locationServicesDisabled,
          );
          return;
        }

      case ErrorResponse():
        _emitLocationError(
          serviceResponse.errorMessage,
        );
        return;
    }

    var permissionResponse =
        await checkLocationPermissionUseCase();

    late LocationPermission permission;

    switch (permissionResponse) {
      case SuccessResponse<LocationPermission>():
        permission = permissionResponse.data;

      case ErrorResponse():
        _emitLocationError(
          permissionResponse.errorMessage,
        );
        return;
    }

    if (permission == LocationPermission.denied) {
      permissionResponse =
          await requestLocationPermissionUseCase();

      switch (permissionResponse) {
        case SuccessResponse<LocationPermission>():
          permission = permissionResponse.data;

        case ErrorResponse():
          _emitLocationError(
            permissionResponse.errorMessage,
          );
          return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _emitLocationError(
        AppString.locationPermissionPermanentlyDenied,
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      _emitLocationError(
        AppString.locationPermissionDenied,
      );
      return;
    }

    await _getLocation();
  }

  Future<void> _getLocation() async {
  final locationResponse =
      await getCurrentLocationUseCase();

  if (isClosed) return;

  switch (locationResponse) {
    case SuccessResponse<LocationEntity>():
      final location = locationResponse.data;

      if (isClosed) return;

      emit(
        state.copyWith(
          locationState: state.locationState.copyWith(
            isLoading: false,
            data: location,
            errorMessage: '',
          ),
        ),
      );

      if (isClosed) return;

      await _getAddressFromLocation(
        latitude: location.latitude,
        longitude: location.longitude,
      );

    case ErrorResponse():
      if (isClosed) return;

      _emitLocationError(
        locationResponse.errorMessage,
      );
  }
}

Future<void> _getAddressFromLocation({
  required double latitude,
  required double longitude,
}) async {
  if (isClosed) return;

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

  if (isClosed) return;

  switch (response) {
    case SuccessResponse<AddressEntity>():
      final current = state.addressState.data;

      if (isClosed) return;

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

    case ErrorResponse():
      if (isClosed) return;

      emit(
        state.copyWith(
          addressState: state.addressState.copyWith(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ),
      );
  }
}

  void _emitLocationError(String message) {
    emit(
      state.copyWith(
        locationState: state.locationState.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
        addressState: state.addressState.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
      ),
    );
  }

  Future<void> openLocationSettings() async {
    await openLocationSettingsUseCase();
  }

  Future<void> openAppSettings() async {
    await openAppSettingsUseCase();
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

    final response =
        await getAddressDetailsUseCase.addressDetails(id);

    switch (response) {
      case SuccessResponse<AddressEntity>():
        final address = response.data;
        final latitude = address.latitude;
        final longitude = address.longitude;
        final hasCoords = latitude != null && longitude != null;

        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              data: address,
              errorMessage: '',
            ),
            locationState: hasCoords
                ? state.locationState.copyWith(
                    isLoading: false,
                    data: LocationEntity(
                      latitude: latitude,
                      longitude: longitude,
                    ),
                    errorMessage: '',
                  )
                : state.locationState,
          ),
        );

      case ErrorResponse():
        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}

