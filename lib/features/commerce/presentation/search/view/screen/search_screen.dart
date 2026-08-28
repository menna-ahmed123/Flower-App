import 'package:flower_app/core/navigation/product_navigation.dart';
import 'package:flower_app/core/widgets/app_search_field.dart';
import 'package:flower_app/features/commerce/core/widgets/product_grid.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            AppSearchField(
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
            SizedBox(height: 8.h),
            Expanded(
              child: BlocBuilder<SearchViewModel, SearchState>(
                builder: (context, state) {
                  final productsState = state.productsState;

                  if (productsState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (productsState.errorMessage.isNotEmpty) {
                    return SearchStatusWidget(text: productsState.errorMessage);
                  }

                  if (productsState.data == null) {
                    return const SearchStatusWidget(
                      text: AppString.searchProducts,
                    );
                  }

                  if (productsState.data!.isEmpty) {
                    return const SearchStatusWidget(
                      text: AppString.noResultsFound,
                    );
                  }

                  return ProductGrid(
                    products: productsState.data!,
                    onTap: (product) {
                      navigateToProductDetails(context, product.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
