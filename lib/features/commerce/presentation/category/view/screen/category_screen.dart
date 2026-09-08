import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_search_field.dart';
import 'package:flower_app/features/commerce/presentation/category/view/widgets/category_body.dart';
import 'package:flower_app/features/commerce/presentation/category/view/widgets/category_sort_bottom_sheet.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_event.dart';
import 'package:flower_app/features/commerce/presentation/category/view_model/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16.h),

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
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
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
                        AppIcons.filter,
                        color: colors.grey.shade700,
                        size: 24.w,
                      ),
                      onPressed: () {
                        final viewModel =
                            context.read<CategoryViewModel>();
                  
                        CategorySortBottomSheet.show(
                          context: context,
                          initialSortBy: viewModel.state.selectedSortBy,
                          onApply: (selectedSort) {
                            viewModel.onEvent(
                              SortProducts(selectedSort),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            const Expanded(
              child: CategoryBody(),
            ),
          ],
        ),
      ),
    );
  }
}
