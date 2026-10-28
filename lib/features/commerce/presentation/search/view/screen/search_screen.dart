import 'package:flower_app/core/navigation/product_navigation.dart';
import 'package:flower_app/core/utils/pagination/pagination_grid_view.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/core/widgets/app_search_field.dart';
import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_event.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_state.dart';
import 'package:flower_app/features/commerce/presentation/search/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_string.dart';
import '../widgets/search_status_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppString.search)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: AppSearchField(
              focusNode: _searchFocusNode,
              onChanged: (query) {
                context.read<SearchViewModel>().onEvent(
                  SearchQueryChanged(query),
                );
              },
              onSubmitted: (query) {
                context.read<SearchViewModel>().onEvent(SearchSubmitted(query));
              },
              onClear: () {
                context.read<SearchViewModel>().onEvent(SearchCleared());
              },
            ),
          ),
          Expanded(
            child: BlocListener<SearchViewModel, SearchState>(
              listenWhen: (previous, current) =>
                  previous.selectedProduct != current.selectedProduct &&
                  current.selectedProduct != null,
              listener: (context, state) {
                navigateToProductDetails(context, state.selectedProduct!.id);
              },
              child: BlocBuilder<SearchViewModel, SearchState>(
                builder: (context, state) {
                  final viewModel = context.read<SearchViewModel>();

                  return ListenableBuilder(
                    listenable: viewModel.productsPaginationController,
                    builder: (context, _) {
                      final paginationState =
                          viewModel.productsPaginationController.state;

                      if (paginationState.status == PaginationStatus.initial) {
                        return const SearchStatusWidget(
                          text: AppString.searchProducts,
                        );
                      }

                      if (paginationState.status == PaginationStatus.loading &&
                          paginationState.items.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (paginationState.status == PaginationStatus.error &&
                          paginationState.items.isEmpty) {
                        return SearchStatusWidget(
                          text:
                              paginationState.errorMessage ??
                              AppString.somethingWrong,
                        );
                      }

                      if (paginationState.items.isEmpty &&
                          paginationState.status == PaginationStatus.success) {
                        return const SearchStatusWidget(
                          text: AppString.noResultsFound,
                        );
                      }

                      return PaginationGridView<ProductEntity>(
                        controller: viewModel.productsPaginationController,
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, product, index) {
                          return ProductCard(
                            productId: product.id,
                            imageUrl: product.imageUrl,
                            name: product.name,
                            price: product.discountedPrice.toStringAsFixed(2),
                            oldPrice: product.price != product.discountedPrice
                                ? product.price?.toStringAsFixed(2)
                                : null,
                            discount: product.discountPercent != null
                                ? '${product.discountPercent!.toStringAsFixed(0)}%'
                                : null,
                            onAddToCart: () async {},
                            onTap: () {
                              viewModel.onEvent(ProductSelected(product));
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
