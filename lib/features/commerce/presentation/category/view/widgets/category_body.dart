import 'package:flower_app/core/auth/auth_extension.dart';
import 'package:flower_app/core/navigation/product_navigation.dart';
import 'package:flower_app/core/utils/pagination/pagination_grid_view.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/commerce/core/widgets/custom_tab_bar.dart';
import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_state.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

            Expanded(child: _buildProductsBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildProductsBody(BuildContext context, CategoryState state) {
    if (state.categoriesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categoriesState.errorMessage.isNotEmpty) {
      return Center(child: Text(state.categoriesState.errorMessage));
    }

    if (state.productsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PaginationGridView<ProductEntity>(
      key: ValueKey('${state.selectedCategoryId}_${state.selectedSortBy}'),
      controller: context
          .read<CategoryViewModel>()
          .productsPaginationController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
          onAddToCart: () async {
            await context.requireAuth(
              action: () async {
                await _addToCart(context, product.id);
              },
            );
          },
          onTap: () {
            navigateToProductDetails(context, product.id);
          },
        );
      },
    );
  }

  Future<void> _addToCart(BuildContext context, String productId) {
    return context.requireAuth(
      action: () {
        return context.read<CartViewModel>().doEvent(
          AddCartItemEvent(productId: productId),
        );
      },
    );
  }
}
