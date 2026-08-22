import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/commerce_widgets/commerce_app_bar.dart';
import 'package:flower_app/core/utils/commerce_widgets/product_grid.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_state.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionScreen extends StatefulWidget {
  const OccasionScreen({super.key});

  @override
  State<OccasionScreen> createState() => _OccasionScreenState();
}

class _OccasionScreenState extends State<OccasionScreen> {
  late final OccasionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<OccasionViewModel>();
    _viewModel.onEvent(LoadOccasions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: BlocBuilder<OccasionViewModel, OccasionState>(
        builder: (context, state) {
          final tabs = _buildTabs(
            state.occasionsState.data ?? const <OccasionModel>[],
          );

          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 70.h,
                    child: CommerceAppBar(
                      title: "Occasion",
                      des: "Bloom with our exquisite best sellers",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 40.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final tab = tabs[index];
                        final isSelected = state.selectedTab == tab;

                        return ChoiceChip(
                          label: Text(tab),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: context.colors.pink.withValues(
                            alpha: 0.12,
                          ),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? context.colors.pink
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? context.colors.pink
                                : Colors.transparent,
                          ),
                          onSelected: (_) {
                            final selectedOccasion =
                                (state.occasionsState.data ??
                                        const <OccasionModel>[])
                                    .firstWhere(
                                      (occasion) => occasion.name == tab,
                                      orElse: () =>
                                          state.occasionsState.data?.first ??
                                          OccasionModel(
                                            id: '',
                                            name: tab,
                                            imageUrl: '',
                                            sortOrder: 0,
                                          ),
                                    );

                            context.read<OccasionViewModel>().onEvent(
                              SelectOccasionTab(
                                occasionId: selectedOccasion.id,
                                tab: tab,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: state.occasionsState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.occasionsState.errorMessage.isNotEmpty
                        ? Center(child: Text(state.occasionsState.errorMessage))
                        : state.productsState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.productsState.errorMessage.isNotEmpty
                        ? Center(child: Text(state.productsState.errorMessage))
                        : (state.productsState.data ?? const []).isEmpty
                        ? const Center(child: Text('No products found'))
                        : ProductGrid(
                            products: state.productsState.data ?? const [],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _buildTabs(List<OccasionModel> occasions) {
    return occasions.map((occasion) => occasion.name).toList();
  }
}
