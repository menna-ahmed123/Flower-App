import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/enums/notification_permission_status.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/home_use_case.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_state.dart';
import 'package:flower_app/features/notification/domain/use_cases/is_notification_permission_granted_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/open_notification_settings_use_case.dart';
import 'package:flower_app/features/notification/domain/use_cases/request_notification_permission_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(
    this._homeUseCase,
    this._isNotificationPermissionGrantedUseCase,
    this._requestNotificationPermissionUseCase,
    this._openNotificationSettingsUseCase,
  ) : super(const HomeState());

  final HomeUseCase _homeUseCase;
  final IsNotificationPermissionGrantedUseCase
  _isNotificationPermissionGrantedUseCase;
  final RequestNotificationPermissionUseCase
  _requestNotificationPermissionUseCase;
  final OpenNotificationSettingsUseCase _openNotificationSettingsUseCase;

  void doEvent(HomeEvent event) {
    switch (event) {
      case HomeRequested():
        _load();
        break;

      case HomeNotificationPermissionRequested(:final notificationsEnabled):
        _handleNotificationPermission(notificationsEnabled);
        break;

      case HomeNotificationSettingsRequested():
        _openNotificationSettings();
        break;

      case HomeNotificationSettingsPromptDismissed():
        _dismissNotificationSettingsDialog();
        break;
    }
  }

  Future<void> _handleNotificationPermission(bool notificationsEnabled) async {
    // Don't check or request permission when notifications are disabled.
    if (!notificationsEnabled) return;

    try {
      var status = await _isNotificationPermissionGrantedUseCase();

      if (status == NotificationPermissionStatus.notDetermined) {
        status = await _requestNotificationPermissionUseCase();
      }

      if (isClosed) return;

      emit(
        state.copyWith(
          shouldShowNotificationSettingsDialog:
              status == NotificationPermissionStatus.denied,
        ),
      );
    } catch (_) {
      // A permission-check failure shouldn't block Home.
    }
  }

  Future<void> _openNotificationSettings() async {
    _dismissNotificationSettingsDialog();
    await _openNotificationSettingsUseCase();
  }

  void _dismissNotificationSettingsDialog() {
    emit(state.copyWith(shouldShowNotificationSettingsDialog: false));
  }

  Future<void> _load() async {
    _emitLoading();

    final response = await _homeUseCase();

    if (response is SuccessResponse<HomeLayoutEntity>) {
      await _dropStaleImages(response.data);
    }

    _onResponse(response);
  }

  Future<void> _dropStaleImages(HomeLayoutEntity data) async {
    for (final section in data.sections) {
      await _dropCachedUrl(section.imageUrl);

      for (final item in section.items) {
        await _dropCachedUrl(item.imageUrl);
      }
    }
  }

  Future<void> _dropCachedUrl(String url) async {
    if (url.isEmpty) return;

    await CachedNetworkImage.evictFromCache(url);
  }

  void _emitLoading() {
    emit(
      state.copyWith(
        homeState: state.homeState.copyWith(isLoading: true, errorMessage: ''),
      ),
    );
  }

  void _onResponse(BaseResponse<HomeLayoutEntity> response) {
    switch (response) {
      case SuccessResponse<HomeLayoutEntity> success:
        _emitSuccess(success.data);
        break;

      case ErrorResponse<HomeLayoutEntity> error:
        _emitError(error.errorMessage);
        break;
    }
  }

  void _emitSuccess(HomeLayoutEntity data) {
    emit(
      state.copyWith(
        homeState: state.homeState.copyWith(
          isLoading: false,
          data: data,
          errorMessage: '',
        ),
      ),
    );
  }

  void _emitError(String message) {
    emit(
      state.copyWith(
        homeState: state.homeState.copyWith(
          isLoading: false,
          errorMessage: message,
        ),
      ),
    );
  }
}
