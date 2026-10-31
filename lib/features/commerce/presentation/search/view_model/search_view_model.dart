import 'dart:async';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/search_use_case.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_event.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchViewModel extends Cubit<SearchState> {
  SearchViewModel(this._searchUseCase) : super(const SearchState()) {
    productsPaginationController = PaginationController<ProductEntity>(
      pageSize: 20,
      fetchPage: _fetchPage,
    );
  }

  final SearchUseCase _searchUseCase;

  late final PaginationController<ProductEntity> productsPaginationController;

  Timer? _debounce;
  String _activeQuery = '';

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
    _activeQuery = '';
    productsPaginationController.reset();

    emit(state.copyWith(query: ''));
  }

  Future<void> _search(String query) async {
    _activeQuery = query;

    emit(state.copyWith(query: query));

    productsPaginationController.reset();
    await productsPaginationController.loadNextPage();
  }

  Future<List<ProductEntity>> _fetchPage(int page, int pageSize) async {
    final response = await _searchUseCase(
      query: _activeQuery,
      page: page,
      pageSize: pageSize,
    );

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        return response.data;

      case ErrorResponse<List<ProductEntity>>():
        throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    productsPaginationController.dispose();
    return super.close();
  }
}
