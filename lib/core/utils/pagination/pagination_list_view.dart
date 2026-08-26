
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

import 'pagination_controller.dart';
import 'pagination_state.dart';

class PaginationListView<T> extends StatefulWidget {
  final PaginationController<T> controller;

  final Widget Function(
    BuildContext context,
    T item,
    int index,
  ) itemBuilder;

  final EdgeInsetsGeometry? padding;

  const PaginationListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.padding,
  });

  @override
  State<PaginationListView<T>> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T>
    extends State<PaginationListView<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);

    widget.controller.addListener(_onPaginationChanged);

    widget.controller.loadNextPage();
  }

  void _onPaginationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      widget.controller.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    widget.controller.removeListener(_onPaginationChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    if (state.status == PaginationStatus.loading &&
        state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == PaginationStatus.error &&
        state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? AppString.somethingWrong,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.controller.retry,
              child: const Text(AppString.retry),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty &&
        state.status == PaginationStatus.success) {
      return const Center(
        child: Text(AppString.noData),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: _getItemCount(state),
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final item = state.items[index];

        return widget.itemBuilder(
          context,
          item,
          index,
        );
      },
    );
  }

  int _getItemCount(PaginationState<T> state) {
    final shouldShowLoadingMore =
        state.status == PaginationStatus.loadingMore;

    final shouldShowError =
        state.status == PaginationStatus.errorLoadingMore;

    if (shouldShowLoadingMore || shouldShowError) {
      return state.items.length + 1;
    }

    return state.items.length;
  }
}