import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flutter/material.dart';

class PaginationController<T> extends ChangeNotifier {
  final Future<List<T>> Function(int page, int pageSize) fetchPage;

  final int pageSize;
  final int firstPage;

  PaginationState<T> state = PaginationState<T>();

  int currentPage = 0;
  bool isRequestInProgress = false;
  int _requestGeneration = 0;

  PaginationController({
    required this.fetchPage,
    this.pageSize = 10,
    this.firstPage = 1,
  });

  Future<void> loadNextPage() async {
    // Prevent duplicate requests
    if (isRequestInProgress) {
      return;
    }

    // No more pages
    if (!state.hasMore) {
      return;
    }

    final bool isFirstPage = currentPage == 0;
    final int generation = _requestGeneration;

    isRequestInProgress = true;

    state = state.copyWith(
      status: isFirstPage
          ? PaginationStatus.loading
          : PaginationStatus.loadingMore,
      errorMessage: null,
    );
    notifyListeners();

    try {
      final int nextPage = isFirstPage ? firstPage : currentPage + 1;

      final List<T> newItems = await fetchPage(nextPage, pageSize);

      if (generation != _requestGeneration) {
        return;
      }

      if (newItems.isEmpty) {
        state = state.copyWith(
          status: PaginationStatus.success,
          hasMore: false,
        );
        notifyListeners();
        return;
      }

      final List<T> updatedItems = [...state.items, ...newItems];

      currentPage = nextPage;

      final bool hasMore = newItems.length == pageSize;

      state = state.copyWith(
        items: updatedItems,
        status: PaginationStatus.success,
        hasMore: hasMore,
      );
      notifyListeners();
    } catch (e) {
      if (generation != _requestGeneration) {
        return;
      }

      state = state.copyWith(
        status: isFirstPage
            ? PaginationStatus.error
            : PaginationStatus.errorLoadingMore,
        errorMessage: e.toString(),
      );
      notifyListeners();
    } finally {
      if (generation == _requestGeneration) {
        isRequestInProgress = false;
      }
    }
  }

  Future<void> retry() async {
    await loadNextPage();
  }

  void reset() {
    _requestGeneration++;
    currentPage = 0;
    isRequestInProgress = false;
    state = PaginationState<T>();
    notifyListeners();
  }

  @override
  void dispose() {
    _requestGeneration++;
    super.dispose();
  }
}
