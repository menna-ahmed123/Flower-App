import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_search_field.dart'; // تأكد من المسار الصحيح للـ AppSearchField
import 'package:flower_app/features/commerce/core/widgets/custom_tab_bar.dart';
import 'package:flower_app/features/commerce/core/widgets/product_grid.dart';
import 'package:flower_app/features/commerce/domain/entities/category_entity.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_state.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, state) {
        final List<CategoryEntity> categories =
            state.categoriesState.data ?? const <CategoryEntity>[];
        final tabs = _buildTabs(categories);

        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  // Row تحتوي على الـ Search Field وزرار الـ Filter Side Icon
                  Row(
                    children: [
                      Expanded(
                        child: AppSearchField(
                          onChanged: (value) {
                            // handle search query
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: colors.grey.shade600),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            AppIcons
                                .filter, // تأكد من اسم الأيقونة لديك أو استخدم Icons.filter_list
                            color: colors.grey.shade700,
                            size: 24.w,
                          ),
                          onPressed: () {
                            // handle open filter drawer or bottom sheet
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Custom Tab Bar
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
                        SelectCategoryTab(
                          categoryId: selectedCategory.id,
                          tab: tab,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Products Body
                  Expanded(child: _buildBody(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(CategoryState state) {
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

  List<String> _buildTabs(List<CategoryEntity> categories) {
    return categories.map((category) => category.name).toList();
  }
}
