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
      case HomeQueryChanged():
        emit(state.copyWith(query: event.query));
    }
  }

  List<HomeSectionEntity> get displayedSections {
    final sections = state.homeState.data?.sections ?? const [];
    final query = state.query.trim();
    if (query.isEmpty) return sections;
    return [for (final section in sections) _filterSection(section, query)];
  }

  HomeSectionEntity _filterSection(HomeSectionEntity section, String query) {
    if (section.type != 'product_rail') return section;
    final q = query.toLowerCase();
    return HomeSectionEntity(
      type: section.type,
      id: section.id,
      title: section.title,
      order: section.order,
      imageUrl: section.imageUrl,
      deepLink: section.deepLink,
      viewAllLabel: section.viewAllLabel,
      viewAllDeepLink: section.viewAllDeepLink,
      items: [
        for (final item in section.items)
          if (item.name.toLowerCase().contains(q)) item,
      ],
    );
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
