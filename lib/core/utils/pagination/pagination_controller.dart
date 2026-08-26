import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flutter/material.dart';

class PaginationController<T>extends ChangeNotifier{
  final Future<List<T>> Function(int page, int pageSize) fetchPage;

  final int pageSize;
  final int firstPage;

  PaginationState<T> state = PaginationState<T>();

  int currentPage = 0;
  bool isRequestInProgress = false;

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

    isRequestInProgress = true;

    state = state.copyWith(
      status: isFirstPage
          ? PaginationStatus.loading
          : PaginationStatus.loadingMore,
      errorMessage: null,
    );
    notifyListeners();

    try {
      final int nextPage =
          isFirstPage ? firstPage : currentPage + 1;

      final List<T> newItems = await fetchPage(
        nextPage,
        pageSize,
      );

      if (newItems.isEmpty) {
        state = state.copyWith(
          status: PaginationStatus.success,
          hasMore: false,
        );
        return;
      }

      final List<T> updatedItems = [
        ...state.items,
        ...newItems,
      ];

      currentPage = nextPage;

      final bool hasMore = newItems.length == pageSize;

      state = state.copyWith(
        items: updatedItems,
        status: PaginationStatus.success,
        hasMore: hasMore,
      );
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        status: isFirstPage
            ? PaginationStatus.error
            : PaginationStatus.errorLoadingMore,
        errorMessage: e.toString(),
      );
      notifyListeners();
    } finally {
      isRequestInProgress = false;
    }
  }

  Future<void> retry() async {
    await loadNextPage();
  }

  void reset() {
    currentPage = 0;
    isRequestInProgress = false;
    state = PaginationState<T>();
    notifyListeners();
  }
}