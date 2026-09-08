import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/search_use_case.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_event.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchViewModel extends Cubit<SearchState> {
  SearchViewModel(this._searchUseCase) : super(const SearchState());

  final SearchUseCase _searchUseCase;

  Timer? _debounce;
  int _searchRequestId = 0;

  void onEvent(SearchEvent event) {
    switch (event) {
      case SearchQueryChanged():
        _onQueryChanged(event.query);

      case SearchSubmitted():
        _onSubmitted(event.query);

      case SearchCleared():
        _onCleared();

      case ProductSelected():
        emit(state.copyWith(selectedProduct: event.product));
    }
  }

  void _onQueryChanged(String query) {
    emit(state.copyWith(query: query));

    _debounce?.cancel();

    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      _onCleared();
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _search(normalizedQuery),
    );
  }

  void _onSubmitted(String query) {
    _debounce?.cancel();

    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      _onCleared();
      return;
    }

    _search(normalizedQuery);
  }

  void _onCleared() {
    _debounce?.cancel();
    _searchRequestId++;

    emit(
      state.copyWith(
        query: '',
        productsState: state.productsState.copyWith(
          isLoading: false,
          data: null,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<void> _search(String query) async {
    final requestId = ++_searchRequestId;

    emit(
      state.copyWith(
        productsState: state.productsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _searchUseCase(query: query);

    if (requestId != _searchRequestId) {
      return;
    }

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
