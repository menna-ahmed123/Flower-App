import 'package:flower_app/features/commerce/core/widgets/custom_tab_bar.dart';
import 'package:flower_app/features/commerce/core/widgets/product_grid.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_state.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryBody extends StatelessWidget {
  const CategoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, state) {
        final categories =
            state.categoriesState.data ?? const <CategoryEntity>[];

        final tabs = categories.map((category) => category.name).toList();

        return Column(
          children: [
            CustomTabBar(
              tabs: tabs,
              selectedTab: state.selectedTab,
              onTabSelected: (tab) {
                final selectedCategory = categories.firstWhere(
                  (category) => category.name == tab,
                  orElse: () => categories.isNotEmpty
                      ? categories.first
                      : CategoryEntity(id: '', name: tab),
                );

                context.read<CategoryViewModel>().onEvent(
                  SelectCategoryTab(categoryId: selectedCategory.id, tab: tab),
                );
              },
            ),

            SizedBox(height: 16.h),

            Expanded(child: _buildProductsBody(state)),
          ],
        );
      },
    );
  }

  Widget _buildProductsBody(CategoryState state) {
    if (state.categoriesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categoriesState.errorMessage.isNotEmpty) {
      return Center(child: Text(state.categoriesState.errorMessage));
    }

    if (state.productsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.productsState.errorMessage.isNotEmpty) {
      return Center(child: Text(state.productsState.errorMessage));
    }

    final products = state.productsState.data ?? const [];

    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return ProductGrid(products: products);
  }
}
