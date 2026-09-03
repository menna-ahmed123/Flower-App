import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/app_shimmer/home_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeViewModel, HomeState>(builder: _buildBody),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    final home = state.homeState;
    if (home.isLoading && home.data == null) return _loading(context);
    if (home.errorMessage.isNotEmpty && home.data == null) {
      return _error(context, home.errorMessage);
    }
    return HomeSectionList(
      sections: context.read<HomeViewModel>().displayedSections,
      onQuery: (query) {
        context.read<HomeViewModel>().doEvent(HomeQueryChanged(query));
      },
    );
  }

  Widget _loading(BuildContext context) {
    return const HomeShimmer();
  }

  Widget _error(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            _retry(context),
          ],
        ),
      ),
    );
  }

  Widget _retry(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<HomeViewModel>().doEvent(HomeRequested()),
      child: const Text(AppString.retry),
    );
  }
}
