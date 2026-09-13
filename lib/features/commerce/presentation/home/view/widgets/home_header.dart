import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_search_field.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_event.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/auth/core/auth_extension.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/bottom_sheet_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.addresses,
    this.selectedAddress,
    this.onAddressSelected,
    this.onAddNewAddress,
  });

  final List<AddressEntity> addresses;

  final AddressEntity? selectedAddress;

  final ValueChanged<AddressEntity>? onAddressSelected;

  final VoidCallback? onAddNewAddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(context),

          SizedBox(height: 12.h),

          AppSearchField(
            readOnly: true,
            onTap: () => context.push(AppRoutesName.search),
          ),

          SizedBox(height: 12.h),

          _deliverTo(context),
        ],
      ),
    );
  }

  String _resolvedAddressText() {
    if ((selectedAddress?.address ?? '').trim().isNotEmpty) {
      return selectedAddress!.address!.trim();
    }
    if ((selectedAddress?.city ?? '').trim().isNotEmpty) {
      return selectedAddress!.city!.trim();
    }
    if ((selectedAddress?.area ?? '').trim().isNotEmpty) {
      return selectedAddress!.area!.trim();
    }
    return AppString.chooseDeliveryAddress;
  }

  Widget _logo(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Icon(AppIcons.florist, color: colors.pink, size: 22.w),

        SizedBox(width: 6.w),

        Text(
          AppString.flowery,
          style: TextStyle(
            color: colors.pink,
            fontSize: 22.sp,
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _deliverTo(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () async {
        await context.requireAuth(
          action: () async {
            context.read<DefaultAddressViewModel>().doEvent(
              LoadSavedAddresses(),
            );
            await _showAddressBottomSheet(context);
          },
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Icon(AppIcons.location, color: colors.black, size: 18.w),

            SizedBox(width: 15.w),

            Expanded(
              child: Text(
                _resolvedAddressText(),
                style: TextStyle(
                  color: colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(AppIcons.keyboardArrowDown, color: colors.pink, size: 20.w),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddressBottomSheet(BuildContext context) async {
    final viewModel = context.read<DefaultAddressViewModel>();
    final result = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider<DefaultAddressViewModel>.value(
          value: viewModel,
          child: BottomSheetAddress(
            selectedAddressId: selectedAddress?.id,
          ),
        );
      },
    );
    if (result is AddressEntity) {
      onAddressSelected?.call(result);
      return;
    }
    if (result == BottomSheetAddress.addNewAddress) {
      onAddNewAddress?.call();
    }
  }
}
