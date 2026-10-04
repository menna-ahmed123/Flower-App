import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_details_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_cities_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_governorates_use_case.dart';
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
  final IsLocationServiceEnabledUseCase isLocationServiceEnabledUseCase;
  final CheckLocationPermissionUseCase checkLocationPermissionUseCase;
  final RequestLocationPermissionUseCase requestLocationPermissionUseCase;
  final OpenLocationSettingsUseCase openLocationSettingsUseCase;
  final OpenAppSettingsUseCase openAppSettingsUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromLocationUseCase getAddressFromLocationUseCase;
  final GetAddressDetailsUseCase getAddressDetailsUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  AddressViewModel(
    this.isLocationServiceEnabledUseCase,
    this.checkLocationPermissionUseCase,
    this.requestLocationPermissionUseCase,
    this.openLocationSettingsUseCase,
    this.openAppSettingsUseCase,
    this.getCurrentLocationUseCase,
    this.getAddressFromLocationUseCase,
    this.getAddressDetailsUseCase,
    this.getGovernoratesUseCase,
    this.getCitiesUseCase,
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

      case LoadGovernorates():
        await _loadGovernorates();
        break;

      case SelectGovernorate(:final governorate):
        await _selectGovernorate(governorate);
        break;

      case SelectCity(:final city):
        _selectCity(city);
        break;
    }
  }

  Future<void> _loadGovernorates() async {
    emit(
      state.copyWith(
        governoratesState: state.governoratesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await getGovernoratesUseCase();

    if (isClosed) return;

    switch (response) {
      case SuccessResponse<List<GovernorateEntity>>(:final data):
        emit(
          state.copyWith(
            governoratesState: state.governoratesState.copyWith(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
          ),
        );

        // Auto-select governorate if address has governorateId
        final currentAddress = state.addressState.data;
        if (currentAddress?.governorateId != null) {
          final matchedGov = data.cast<GovernorateEntity?>().firstWhere(
                (g) => g?.id == currentAddress!.governorateId,
                orElse: () => null,
              );
          if (matchedGov != null) {
            await _selectGovernorate(matchedGov, preserveCityId: currentAddress?.cityId);
          }
        }
        break;

      case ErrorResponse<List<GovernorateEntity>>(:final errorMessage):
        emit(
          state.copyWith(
            governoratesState: state.governoratesState.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _selectGovernorate(
    GovernorateEntity? governorate, {
    int? preserveCityId,
  }) async {
    if (governorate == null) {
      emit(
        state.copyWith(
          selectedGovernorate: () => null,
          selectedCity: () => null,
          citiesState: const BaseState(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedGovernorate: () => governorate,
        selectedCity: () => null,
        citiesState: state.citiesState.copyWith(
          isLoading: true,
          errorMessage: '',
          data: [],
        ),
      ),
    );

    final govId = governorate.id;
    if (govId == null) {
      emit(
        state.copyWith(
          citiesState: state.citiesState.copyWith(
            isLoading: false,
            data: [],
          ),
        ),
      );
      return;
    }

    final response = await getCitiesUseCase(govId);

    if (isClosed) return;

    switch (response) {
      case SuccessResponse<List<CityEntity>>(:final data):
        CityEntity? initialCity;
        final targetCityId = preserveCityId ?? state.addressState.data?.cityId;
        if (targetCityId != null) {
          initialCity = data.cast<CityEntity?>().firstWhere(
                (c) => c?.id == targetCityId,
                orElse: () => null,
              );
        }

        emit(
          state.copyWith(
            citiesState: state.citiesState.copyWith(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
            selectedCity: initialCity != null ? () => initialCity : null,
          ),
        );
        break;

      case ErrorResponse<List<CityEntity>>(:final errorMessage):
        emit(
          state.copyWith(
            citiesState: state.citiesState.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );
        break;
    }
  }

  void _selectCity(CityEntity? city) {
    emit(
      state.copyWith(
        selectedCity: () => city,
      ),
    );
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

    final serviceResponse = await isLocationServiceEnabledUseCase();

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

    var permissionResponse = await checkLocationPermissionUseCase();

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
      permissionResponse = await requestLocationPermissionUseCase();

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
    final locationResponse = await getCurrentLocationUseCase();

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
        locationState: state.locationState.copyWith(
          data: LocationEntity(latitude: latitude, longitude: longitude),
          isLoading: false,
          errorMessage: '',
        ),
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

        final resolved = response.data;
        emit(
          state.copyWith(
            addressState: state.addressState.copyWith(
              isLoading: false,
              data: resolved.copyWith(
                id: current?.id,
                phoneNumber: current?.phoneNumber,
                recipientName: current?.recipientName,
                label: current?.label,
                governorateId: current?.governorateId,
                cityId: current?.cityId,
                isDefault: current?.isDefault ?? false,
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

    final response = await getAddressDetailsUseCase.addressDetails(id);

    if (isClosed) return;

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

        await _loadGovernorates();

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
