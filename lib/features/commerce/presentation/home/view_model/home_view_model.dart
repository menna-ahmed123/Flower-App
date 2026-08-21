import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/home_use_case.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(this._homeUseCase) : super(const HomeState());

  final HomeUseCase _homeUseCase;

  void doEvent(HomeEvent event) {
    switch (event) {
      case HomeRequested():
        _load();
    }
  }

  Future<void> _load() async {
    _emitLoading();
    final response = await _homeUseCase();
    _onResponse(response);
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
      case ErrorResponse<HomeLayoutEntity> error:
        _emitError(error.errorMessage);
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
